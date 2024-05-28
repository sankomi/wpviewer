class Post {

	String title;
	String slug;
	String excerpt;
	String content;

	Post._({required String title, required String slug, required String excerpt, required String content}):
		this.title = title,
		this.slug = slug,
		this.excerpt = excerpt,
		this.content = content;

	factory Post.fromJson(Map<String, dynamic> json) {
		return Post._(
			title: json["title"]["rendered"],
			slug: json["slug"],
			excerpt: json["excerpt"]["rendered"],
			content: json["content"]["rendered"],
		);
	}

}
