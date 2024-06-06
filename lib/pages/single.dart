import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_widget_from_html/flutter_widget_from_html.dart";

import "blog.dart";
import "../utils/wp.dart";
import "../utils/routes.dart";
import "../components/menu.dart";

class Single extends StatefulWidget {

	Single({required String this.slug, bool this.page = false});

	Single.home():
		this.slug = Wp.homeSlug ?? "home",
		this.page = true;

	String slug;
	bool page;

	@override
	State<Single> createState() => _SingleState();

}

class _SingleState extends State<Single> {

	bool _error = false;
	bool _notFound = false;
	Post? _post = null;

	@override
	void initState() {
		loadPost();
	}

	Future<void> loadPost() async {
		setState(() {
			_error = false;
			_notFound = false;
		});

		Post? post;
		try {
			if (widget.page) {
				post = await Wp.getPage(slug: widget.slug);
			} else {
				post = await Wp.getPost(slug: widget.slug);
			}

			if (post == null) {
				setState(() => _notFound = true);
			} else {
				setState(() => _post = post!);
			}
		} on Exception catch (err) {
			setState(() => _error = true);
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: _error?
					Text("error!"):
						_notFound?
							Text("not found!"):
							_post == null?
								Text("fectching ${widget.page? 'page': 'post'}..."):
								Text(_post!.title),
				),
			endDrawer: Menu(),
			body: Container(
				padding: EdgeInsets.all(10),
				child: _error?
					Center(
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Text("error!"),
								Container(
									child: TextButton(
										child: Text(
											"retry",
											style: Theme.of(context).textTheme.bodyMedium,
										),
										style: TextButton.styleFrom(
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.zero,
											),
											padding: EdgeInsets.symmetric(
												vertical: 0,
												horizontal: 10,
											),
										),
										onPressed: () => loadPost(),
									),
									margin: EdgeInsets.only(top: 10),
									decoration: BoxDecoration(
										border: Border.all(
											width: 1,
											color: Color(0xffcccccc),
										),
									),
								),
							],
						),
					):
					_notFound?
						Center(
							child: Column(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
									Text("not found!"),
									Container(
										child: TextButton(
											child: Text(
												"retry",
												style: Theme.of(context).textTheme.bodyMedium,
											),
											style: TextButton.styleFrom(
												shape: RoundedRectangleBorder(
													borderRadius: BorderRadius.zero,
												),
												padding: EdgeInsets.symmetric(
													vertical: 0,
													horizontal: 10,
												),
											),
											onPressed: () => loadPost(),
										),
										margin: EdgeInsets.only(top: 10),
										decoration: BoxDecoration(
											border: Border.all(
												width: 1,
												color: Color(0xffcccccc),
											),
										),
									),
								],
							),
						):
						_post == null?
							Center(child: CircularProgressIndicator()):
							RefreshIndicator(
								onRefresh: () => loadPost(),
								child: LayoutBuilder(
									builder: (BuildContext context, BoxConstraints constraints) => SingleChildScrollView(
										physics: AlwaysScrollableScrollPhysics(),
										child: ConstrainedBox(
											constraints: BoxConstraints(
												minHeight: constraints.maxHeight,
											),
											child: HtmlWidget(
												_post!.content,
												onTapUrl: (url) {
													String? slug = Wp.getSlug(url);
													if (slug == null) return false;

													bool page = Wp.isPage(url);
													Navigator.push(context, Routes.slideIn(() => Single(slug: slug!, page: page)));
													return true;
												},
											),
										),
									),
								),
							),
			),
		);
	}

}
