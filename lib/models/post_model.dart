// Each post has an `id`, `title`, and `body`
class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

// Factory constructor for creating a `Post` from a JSON map
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

//blueprint for the fetched data from API and displayed. 