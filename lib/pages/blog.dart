import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_widget_from_html/flutter_widget_from_html.dart";

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
				titleTextStyle: Theme.of(context).textTheme.titleMedium,
				backgroundColor: Theme.of(context).colorScheme.primary,
				centerTitle: true,
			),
			body: FutureBuilder<http.Response>(
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
									String excerpt = post["excerpt"]["rendered"];
									return Post(
										title: title,
										excerpt: excerpt,
									);
								},
								separatorBuilder: (BuildContext context, int index) {
									return SizedBox(height: 10);
								},
								padding: EdgeInsets.all(10),
							);
						} else {
							return Text("error!");
						}
					} else {
						return Text("fetching posts...");
					}
				},
			),
		);
	}

}

class Post extends StatelessWidget {

	String title;
	String excerpt;

	Post({required this.title, required this.excerpt});

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
			onPressed: () => print("hello"),
		);
	}

}
