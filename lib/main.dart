import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/gestures.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

import "pages/blog.dart";
import "utils/wp.dart";

void main() async {
	await dotenv.load();
	Wp.url = dotenv.env["WP_URL"];

	runApp(WpViewer());
}

class WpViewer extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		ColorScheme colourScheme = ColorScheme.light(primary: Color(0xffdc143c));
		TextTheme textTheme = TextTheme(
			titleMedium: TextStyle(
				fontSize: 24,
				color: colourScheme.onPrimary,
			),
			bodyLarge: TextStyle(fontSize: 24),
			bodyMedium: TextStyle(fontSize: 16),
		);
		AppBarTheme appBarTheme = AppBarTheme(
			titleTextStyle: textTheme.titleMedium,
			centerTitle: true,
			backgroundColor: colourScheme.primary,
			iconTheme: IconThemeData(
				color: colourScheme.onPrimary,
			),
		);

		return MaterialApp(
			home: Blog(),
			scrollBehavior: MaterialScrollBehavior()
				.copyWith(dragDevices: PointerDeviceKind.values.toSet()),
			theme: ThemeData(
				textTheme: textTheme,
				appBarTheme: appBarTheme,
				colorScheme: colourScheme,
			),
		);
	}

}
