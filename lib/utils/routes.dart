import "package:flutter/material.dart";

class Routes {

	static Route slideIn(Widget Function() createPage) {
		Duration duration = Duration(milliseconds: 500);

		return PageRouteBuilder(
			pageBuilder: (context, animation, secondaryAnimation) => createPage(),
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
		);
	}

}
