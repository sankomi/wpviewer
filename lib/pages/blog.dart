import "dart:async";
import "dart:convert";
import "dart:ui";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_widget_from_html/flutter_widget_from_html.dart";

import "post.dart";

class Blog extends StatefulWidget {

	@override
	State<Blog> createState() => _BlogState();

}

class _BlogState extends State<Blog> {

	late Future<http.Response> _postsFuture;

	@override
	void initState() {
		String wpUrl = dotenv.env["WP_URL"] ?? "";
		String url = wpUrl + "/wp-json/wp/v2/posts";
		setState(() {
			_postsFuture = http.get(Uri.parse(url));
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("blog"),
			),
			body: Container(
				child: FutureBuilder<http.Response>(
					future: _postsFuture,
					builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							http.Response? res = snapshot.data;
							if (res != null && res.statusCode == 200) {
								List<dynamic> data = jsonDecode(res.body) as List<dynamic>;

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
							} else {
								return Center(child: Text("error!"));
							}
						} else {
							return Center(child: Text("fetching posts..."));
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
						Animatable<Offset> leave = ReverseTween(tween).chain(curveTween);

						return SlideTransition(
							position: secondaryAnimation.drive(leave),
							child: SlideTransition(
								position: animation.drive(enter),
								child: child,
							),
						);
					}
				));
			},
		);
	}

}
