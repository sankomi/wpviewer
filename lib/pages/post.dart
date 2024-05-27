import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_widget_from_html/flutter_widget_from_html.dart";

import "../utils/wp.dart";

class Post extends StatefulWidget {

	Post({required String this.slug});

	String slug;

	@override
	State<Post> createState() => _PostState();

}

class _PostState extends State<Post> {

	late Future<Map<String, dynamic>?> _postFuture;

	@override
	void initState() {
		setState(() {
			_postFuture = Wp.getPost(slug: widget.slug);
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: FutureBuilder<Map<String, dynamic>?>(
					future: _postFuture,
					builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							if (snapshot.data == null) {
								return Text("error!");
							} else {
								Map<String, dynamic> post = snapshot.data!;
								return Text(post["title"]["rendered"]);
							}
						} else {
							return Text("fectching post...");
						}
					},
				),
			),
			body: Container(
				child: FutureBuilder<Map<String, dynamic>?>(
					future: _postFuture,
					builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							if (snapshot.data == null) {
								return Center(child: Text("error!"));
							} else {
								Map<String, dynamic> post = snapshot.data!;

								return SingleChildScrollView(
									child: HtmlWidget(
										post["content"]["rendered"],
										onTapUrl: (url) {
											String? slug = Wp.getSlug(url);
											if (slug == null) return false;

											Duration duration = Duration(milliseconds: 500);

											Navigator.push(context, PageRouteBuilder(
												pageBuilder: (context, animation, secondaryAnimation) => Post(slug: slug!),
												transitionDuration: duration,
												reverseTransitionDuration: duration,
												transitionsBuilder: (context, animation, secondaryAnimation, child) {
													Offset begin = Offset(1.0, 0.0);
													Offset end = Offset.zero;
													Tween<Offset> tween = Tween(begin: begin, end: end);
													CurveTween curveTween = CurveTween(curve: Curves.ease);
													Animatable<Offset> enter = tween.chain(curveTween);

													return SlideTransition(
														position: animation.drive(enter),
														child: child,
													);
												}
											));

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
