import "package:flutter/material.dart";

import "../utils/routes.dart";
import "../pages/single.dart";
import "../pages/blog.dart";

class Menu extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return Drawer(
			child: Container(
				padding: EdgeInsets.symmetric(vertical: 40),
				child: ListView(
					children: [
						MenuItem("home", () => Single.home()),
						MenuItem("blog", () => Blog()),
					],
				),
			),
		);
	}

}

class MenuItem extends StatelessWidget {

	String text;
	Widget Function() createPage;

	MenuItem(String this.text, Widget Function() this.createPage);

	@override
	Widget build(BuildContext context) {
		return TextButton(
			child: Text(
				text,
				style: Theme.of(context).textTheme.bodyLarge,
			),
			style: TextButton.styleFrom(
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.zero,
				),
				padding: EdgeInsets.all(20),
			),
			onPressed: () {
				Navigator.pushAndRemoveUntil(
					context,
					Routes.slideIn(createPage),
					(Route<dynamic> route) => false,
				);
			},
		);
	}

}
