import "package:flutter/material.dart";

import "pages/blog.dart";

void main() {
	runApp(WpViewer());
}

class WpViewer extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			home: Blog(),
			theme: ThemeData(
				textTheme: TextTheme(
					titleMedium: TextStyle(
						fontSize: 24,
						color: Theme.of(context).colorScheme.onPrimary,
					),
					bodyLarge: TextStyle(fontSize: 24),
					bodyMedium: TextStyle(fontSize: 16),
				),
				colorScheme: ColorScheme.light(
					primary: Color(0xffdc143c),
				),
			),
		);
	}

}
