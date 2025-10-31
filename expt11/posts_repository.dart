import 'package:dio/dio.dart';
import 'post_model.dart';

class PostsRepository {
  final Dio _dio;

  PostsRepository({Dio? dio}) : _dio = dio ?? Dio();

  // Fetch posts from JSONPlaceholder
  Future<List<Post>> fetchPosts() async {
    final response = await _dio.get('https://jsonplaceholder.typicode.com/posts');
    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts: \${response.statusCode}');
    }
  }
}
