import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_widget_from_html/flutter_widget_from_html.dart";

import "post.dart";
import "../utils/request.dart";

class Blog extends StatefulWidget {

	@override
	State<Blog> createState() => _BlogState();

}

class _BlogState extends State<Blog> {

	late Future<List<dynamic>> _postsFuture;

	@override
	void initState() {
		String wpUrl = dotenv.env["WP_URL"] ?? "";
		String url = wpUrl + "/wp-json/wp/v2/posts";
		setState(() {
			_postsFuture = Request.get(url)
				.then((data) => data as List<dynamic>);
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("blog"),
			),
			body: Container(
				child: FutureBuilder<List<dynamic>>(
					future: _postsFuture,
					builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							if (snapshot.data == null) {
								return Center(child: Text("error!"));
							} else {
								List<dynamic> data = snapshot.data!;

								return ListView.separated(
									itemCount: data.length,
									itemBuilder: (BuildContext context, int index) {
										Map<String, dynamic> post = data[index];
										String title = post["title"]["rendered"];
										String slug = post["slug"];
										String excerpt = post["excerpt"]["rendered"];
										return PostItem(
											title: title,
											slug: slug,
											excerpt: excerpt,
										);
									},
									separatorBuilder: (BuildContext context, int index) {
										return SizedBox(height: 10);
									},
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

class PostItem extends StatelessWidget {

	String title;
	String slug;
	String excerpt;

	PostItem({required String this.title, required String this.slug, required String this.excerpt});

	@override
	Widget build(BuildContext context) {
		return TextButton(
			child: Container(
				padding: EdgeInsets.symmetric(
					vertical: 10,
					horizontal: 20,
				),
				decoration: BoxDecoration(
					border: Border.all(
						width: 1,
						color: Color(0xffcccccc),
					),
				),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Text(
							title,
							style: Theme.of(context).textTheme.bodyLarge,
						),
						HtmlWidget(
							excerpt,
							textStyle: Theme.of(context).textTheme.bodyMedium,
						),
					],
				),
			),
			style: TextButton.styleFrom(
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.zero,
				),
				padding: EdgeInsets.all(0),
			),
			onPressed: () {
				Duration duration = Duration(milliseconds: 500);

				Navigator.push(context, PageRouteBuilder(
					pageBuilder: (context, animation, secondaryAnimation) => Post(slug: slug),
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
			},
		);
	}

}
