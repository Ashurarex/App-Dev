import 'package:flutter/foundation.dart';
import 'posts_repository.dart';
import 'post_model.dart';

enum ViewState { idle, busy, empty, error }

class PostsViewModel extends ChangeNotifier {
  final PostsRepository _repo;
  List<Post> posts = [];
  ViewState state = ViewState.idle;
  String? message;

  PostsViewModel(this._repo);

  Future<void> loadPosts() async {
    state = ViewState.busy;
    message = null;
    notifyListeners();
    try {
      final result = await _repo.fetchPosts();
      if (result.isEmpty) {
        state = ViewState.empty;
        posts = [];
      } else {
        state = ViewState.idle;
        posts = result;
      }
    } catch (e) {
      state = ViewState.error;
      message = e.toString();
      posts = [];
    }
    notifyListeners();
  }
}
