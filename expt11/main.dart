import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/posts_repository.dart';
import 'src/posts_viewmodel.dart';
import 'src/posts_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = PostsRepository(); // uses Dio internally
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostsViewModel(repo)),
      ],
      child: MaterialApp(
        title: 'Fetch REST API — Flutter',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const PostsListPage(),
      ),
    );
  }
}
