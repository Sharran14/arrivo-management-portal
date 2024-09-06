import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post_model.dart';

// responsible for fetching posts from remote API
class PostService {

  // This method makes an HTTP GET request to API and returns
  // a list of `Post` objects if successful. If the request fails,
  // it throws an exception.
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
