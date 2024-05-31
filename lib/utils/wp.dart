import "dart:async";

import "request.dart";
import "../models/post.dart";

export "../models/post.dart" show Post;

class Wp {

	static String? _wpUrl;

	static void set url(String? url) {
		_wpUrl = url;
	}

	static Future<List<Post>?> getPosts({int page = 1, int perPage = 10}) async {
		if (_wpUrl == null) return null;
		String wpUrl = _wpUrl!;

		String url = wpUrl + "/wp-json/wp/v2/posts?page=${page}&per_page=${perPage}";
		List<Map<String, dynamic>> list = await Request.get(url)
			.then((res) {
				int pages = int.parse(res.headers["x-wp-totalpages"] as String) ?? 0;
				List<dynamic> list = res.data as List<dynamic>;

				return list.map((item) {
					Map<String, dynamic> map = item as Map<String, dynamic>;
					map["pages"] = pages;
					return map;
				}).toList();
			});

		return list.map((json) => Post.fromJson(json))
			.toList();
	}

	static Future<Post?> getPost({required String slug}) async {
		if (_wpUrl == null) return null;
		String wpUrl = _wpUrl!;

		String url = wpUrl + "/wp-json/wp/v2/posts?slug=${slug}";
		List<dynamic> data = await Request.get(url)
			.then((res) => res.data as List<dynamic>);

		if (data.length == 0) return null;

		Map<String, dynamic> json = data.first as Map<String, dynamic>;

		return Post.fromJson(json);
	}

	static String? getSlug(String url) {
		if (_wpUrl == null) return null;
		String wpUrl = _wpUrl!;

		if (!url.startsWith(wpUrl)) return null;

		return url.substring(wpUrl.length)
			.split("/")
			.where((segment) => segment != "")
			.last;
	}

}
