import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_widget_from_html/flutter_widget_from_html.dart";

import "blog.dart";
import "../utils/wp.dart";
import "../utils/routes.dart";
import "../components/menu.dart";

class Single extends StatefulWidget {

	Single({required String this.slug, bool this.page = false});

	Single.home():
		this.slug = Wp.homeSlug ?? "home",
		this.page = true;

	String slug;
	bool page;

	@override
	State<Single> createState() => _SingleState();

}

class _SingleState extends State<Single> {

	late Future<Post?> _postFuture;

	@override
	void initState() {
		setState(() {
			if (widget.page) {
				_postFuture = Wp.getPage(slug: widget.slug);
			} else {
				_postFuture = Wp.getPost(slug: widget.slug);
			}
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: FutureBuilder<Post?>(
					future: _postFuture,
					builder: (BuildContext context, AsyncSnapshot<Post?> snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							if (snapshot.data == null) {
								return Text("error!");
							} else {
								Post post = snapshot.data!;
								return Text(post.title);
							}
						} else {
							return Text("fectching post...");
						}
					},
				),
			),
			endDrawer: Menu(),
			body: Container(
				child: FutureBuilder<Post?>(
					future: _postFuture,
					builder: (BuildContext context, AsyncSnapshot<Post?> snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							if (snapshot.data == null) {
								return Center(child: Text("error!"));
							} else {
								Post post = snapshot.data!;

								return SingleChildScrollView(
									child: HtmlWidget(
										post.content,
										onTapUrl: (url) {
											String? slug = Wp.getSlug(url);
											if (slug == null) return false;

											Navigator.push(context, Routes.slideIn(() => Single(slug: slug!)));
											return true;
										},
									),
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
