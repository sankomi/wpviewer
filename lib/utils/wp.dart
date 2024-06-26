import "dart:async";

import "request.dart";
import "../models/post.dart";

export "../models/post.dart" show Post;

class Wp {

	static String? _wpUrl;
	static String? _homeSlug;

	static void set url(String? url) {
		_wpUrl = url;
	}

	static void set homeSlug(String? homeSlug) {
		_homeSlug = homeSlug;
	}

	static String? get homeSlug {
		return _homeSlug;
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

	static Future<Post?> getPost({required String slug, bool page = false}) async {
		if (_wpUrl == null) return null;
		String wpUrl = _wpUrl!;

		String url = wpUrl + "/wp-json/wp/v2/${page? 'page': 'post'}s?slug=${slug}";
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

	static bool isPage(String url) {
		if (_wpUrl == null) return false;
		String wpUrl = _wpUrl!;

		if (!url.startsWith(wpUrl)) return false;

		Iterable<String> segments = url.substring(wpUrl.length)
			.split("/")
			.where((segment) => segment != "");

		return segments.length == 1;
	}

	static Future<Post?> getPage({required String slug}) async {
		return getPost(slug: slug, page: true);
	}

}
