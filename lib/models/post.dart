class Post {

	int pages;
	String title;
	String slug;
	String excerpt;
	String content;

	Post._({required String title, required String slug, required String excerpt, required String content, int pages = 0}):
		this.title = title,
		this.slug = slug,
		this.excerpt = excerpt,
		this.content = content,
		this.pages = pages;

	factory Post.fromJson(Map<String, dynamic> json) {
		return Post._(
			title: json["title"]["rendered"],
			slug: json["slug"],
			excerpt: json["excerpt"]["rendered"],
			content: json["content"]["rendered"],
			pages: json["pages"],
		);
	}

}
