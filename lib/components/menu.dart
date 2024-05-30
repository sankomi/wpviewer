import "package:flutter/material.dart";

import "../utils/routes.dart";
import "../pages/blog.dart";

class Menu extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return Drawer(
			child: ListView(
				children: [
					Container(
						padding: EdgeInsets.symmetric(vertical: 40),
						child: TextButton(
							child: Text(
								"blog",
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
									Routes.slideIn(() => Blog()),
									(Route<dynamic> route) => false,
								);
							},
						),
					),
				],
			),
		);
	}

}
