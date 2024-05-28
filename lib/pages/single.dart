import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_widget_from_html/flutter_widget_from_html.dart";

import "../utils/wp.dart";

class Single extends StatefulWidget {

	Single({required String this.slug});

	String slug;

	@override
	State<Single> createState() => _SingleState();

}

class _SingleState extends State<Single> {

	late Future<Post?> _postFuture;

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

											Duration duration = Duration(milliseconds: 500);

											Navigator.push(context, PageRouteBuilder(
												pageBuilder: (context, animation, secondaryAnimation) => Single(slug: slug!),
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
