import "package:flutter/material.dart";

class Blog extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("blog"),
				titleTextStyle: Theme.of(context).textTheme.titleMedium,
				backgroundColor: Theme.of(context).colorScheme.primary,
				centerTitle: true,
			),
			body: ListView.separated(
				itemCount: 20,
				itemBuilder: (BuildContext context, int index) {
					return Post(
						title: "title " + (index + 1).toString(),
						excerpt: "excerpt " + (index + 1).toString(),
					);
				},
				separatorBuilder: (BuildContext context, int index) {
					return SizedBox(height: 10);
				},
				padding: EdgeInsets.all(10),
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
						Text(
							excerpt,
							style: Theme.of(context).textTheme.bodyMedium,
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
