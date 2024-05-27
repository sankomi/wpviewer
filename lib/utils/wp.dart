import "dart:async";

import "request.dart";

class Wp {

	static String? _wpUrl;

	static void set url(String? url) {
		_wpUrl = url;
	}

	static Future<List<Map<String, dynamic>>?> getPosts({int page = 1, int perPage = 10}) async {
		if (_wpUrl == null) return null;
		String wpUrl = _wpUrl!;

		String url = wpUrl + "/wp-json/wp/v2/posts?page=${page}&per_page=${perPage}";
		return await Request.get(url)
			.then((res) => res.data as List<dynamic>)
			.then((list) {
				return list.map((item) => item as Map<String, dynamic>)
					.toList();
			});
	}

	static Future<Map<String, dynamic>?> getPost({required String slug}) async {
		if (_wpUrl == null) return null;
		String wpUrl = _wpUrl!;

		String url = wpUrl + "/wp-json/wp/v2/posts?slug=${slug}";
		List<dynamic> data = await Request.get(url)
			.then((res) => res.data as List<dynamic>);

		if (data.length == 0) return null;

		return data.first as Map<String, dynamic>;
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
