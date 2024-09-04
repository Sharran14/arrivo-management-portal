import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post_model.dart';

class PostService {
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
