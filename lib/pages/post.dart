import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_widget_from_html/flutter_widget_from_html.dart";

import "../utils/request.dart";

class Post extends StatefulWidget {

	Post({required String this.slug});

	String slug;

	@override
	State<Post> createState() => _PostState();

}

class _PostState extends State<Post> {

	late Future<List<dynamic>> _postFuture;

	@override
	void initState() {
		String wpUrl = dotenv.env["WP_URL"] ?? "";
		String url = wpUrl + "/wp-json/wp/v2/posts?slug=${widget.slug}";
		setState(() {
			_postFuture = Request.get(url)
				.then((data) => data as List<dynamic>);
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: FutureBuilder<List<dynamic>>(
					future: _postFuture,
					builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							if (snapshot.data == null) {
								return Text("error!");
							} else {
								List<dynamic> data = snapshot.data!;

								Map<String, dynamic> post = data[0] as Map<String, dynamic>;
								return Text(post["title"]["rendered"]);
							}
						} else {
							return Text("fectching post...");
						}
					},
				),
			),
			body: Container(
				child: FutureBuilder<List<dynamic>>(
					future: _postFuture,
					builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							if (snapshot.data == null) {
								return Center(child: Text("error!"));
							} else {
								List<dynamic> data = snapshot.data!;

								Map<String, dynamic> post = data[0] as Map<String, dynamic>;
								return SingleChildScrollView(
									child: HtmlWidget(post["content"]["rendered"]),
								);
							}
						} else {
							return Center(child: CircularProgressIndicator());
						}
					},
				),
				padding: EdgeInsets.all(10),
			),
		);
	}

}
