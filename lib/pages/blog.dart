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
	bool _error = false;
	List<Post> _posts = [];

	ScrollController _scrollController = ScrollController();

	@override
	void initState() {
		loadMore();
		_scrollController.addListener(onScroll);
	}

	void onScroll() {
		if (_scrollController.hasClients) {
			if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
				loadMore();
			}
		} else {
			loadMore();
		}
	}

	void loadMore() async {
		setState(() => _error = false);

		try {
			if (_loading || !_more) return;
			setState(() => _loading = true);

			List<Post>? fetched = await Wp.getPosts(page: _currentPage);

			if (fetched != null) {
				setState(() {
					_posts.addAll(fetched);
					_currentPage++;

					_more = _posts.last.pages >= _currentPage;
					_loading = false;
				});

				onScroll();
			}
		} on Exception catch (err) {
			setState(() {
				_loading = false;
				_more = false;
				_error = true;
			});
		}
	}

	Future<void> refresh() async {
		setState(() {
			_currentPage = 1;
			_more = true;
			_posts.clear();
		});

		loadMore();
	}

	@override
	Widget build(BuildContext context) {
		if (_error) {
			return Center(
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
								onPressed: () => refresh(),
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
			);
		} else if (_posts.length > 0) {
			return RefreshIndicator(
				onRefresh: refresh,
				child: ListView.separated(
					controller: _scrollController,
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
								return SizedBox();
							}
						}
					},
					separatorBuilder: (BuildContext context, int index) {
						return SizedBox(height: 10);
					},
				),
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
