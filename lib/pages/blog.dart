import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_widget_from_html/flutter_widget_from_html.dart";

import "single.dart";
import "../utils/wp.dart";
import "../utils/routes.dart";
import "../components/menu.dart";

class Blog extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("blog"),
			),
			endDrawer: Menu(),
			body: Container(
				child: PostList(),
				padding: EdgeInsets.all(10),
			),
		);
	}

}

class PostList extends StatefulWidget {

	@override
	State<PostList> createState() => _PostListState();

}

class _PostListState extends State<PostList> {

	int _currentPage = 1;
	bool _loading = false;
	bool _more = true;
	List<Post> _posts = [];

	@override
	void initState() {
		loadMore();
	}

	void loadMore() async {
		if (_loading) return;
		setState(() => _loading = true);

		List<Post>? fetched = await Wp.getPosts(page: _currentPage);

		if (fetched != null) {
			setState(() {
				_posts.addAll(fetched);
				_currentPage++;

				_more = _posts.last.pages >= _currentPage;
				_loading = false;
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		if (_posts.length > 0) {
			return ListView.separated(
				itemCount: _posts.length + (_more? 1: 0),
				itemBuilder: (BuildContext context, int index) {
					if (index < _posts.length) {
						Post post = _posts[index];
						return PostItem(
							title: post.title,
							slug: post.slug,
							excerpt: post.excerpt,
						);
					} else {
						if (_loading) {
							return Center(
								child: Container(
									child: CircularProgressIndicator(),
									margin: EdgeInsets.all(15),
								),
							);
						} else {
							return TextButton(
								child: Container(
									child: Center(child: Text("more")),
									width: MediaQuery.of(context).size.width,
									padding: EdgeInsets.all(15),
									decoration: BoxDecoration(
										border: Border.all(
											width: 1,
											color: Color(0xffcccccc),
										),
									),
								),
								style: TextButton.styleFrom(
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.zero,
									),
									padding: EdgeInsets.all(0),
								),
								onPressed: () => loadMore(),
							);
						}
					}
				},
				separatorBuilder: (BuildContext context, int index) {
					return SizedBox(height: 10);
				},
			);
		} else {
			return Center(child: CircularProgressIndicator());
		}
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
				Navigator.push(context, Routes.slideIn(() => Single(slug: slug)));
			},
		);
	}

}
