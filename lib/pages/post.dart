import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_widget_from_html/flutter_widget_from_html.dart";

class Post extends StatefulWidget {

	Post({required String this.slug});

	String slug;

	@override
	State<Post> createState() => _PostState();

}

class _PostState extends State<Post> {

	late Future<http.Response> _postFuture;

	@override
	void initState() {
		String wpUrl = dotenv.env["WP_URL"] ?? "";
		String url = wpUrl + "/wp-json/wp/v2/posts?slug=${widget.slug}";
		setState(() {
			_postFuture = http.get(Uri.parse(url));
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: FutureBuilder<http.Response>(
					future: _postFuture,
					builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							http.Response? res = snapshot.data;
							if (res != null && res.statusCode == 200) {
								List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
								Map<String, dynamic> post = data[0] as Map<String, dynamic>;

								return Text(post["title"]["rendered"]);
							} else {
								return Text("error!");
							}
						} else {
							return Text("fectching post...");
						}
					},
				),
			),
			body: Container(
				child: FutureBuilder<http.Response>(
					future: _postFuture,
					builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							http.Response? res = snapshot.data;
							if (res != null && res.statusCode == 200) {
								List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
								Map<String, dynamic> post = data[0] as Map<String, dynamic>;

								return SingleChildScrollView(
									child: HtmlWidget(post["content"]["rendered"]),
								);
							} else {
								return Center(child: Text("error!"));
							}
						} else {
							return Center(child: Text("fetching post..."));
						}
					},
				),
				padding: EdgeInsets.all(10),
			),
		);
	}

}
