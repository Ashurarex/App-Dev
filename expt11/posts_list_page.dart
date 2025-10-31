import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'posts_viewmodel.dart';
import 'post_model.dart';

class PostsListPage extends StatefulWidget {
  const PostsListPage({super.key});

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  @override
  void initState() {
    super.initState();
    // Load posts when page appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostsViewModel>(context, listen: false).loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PostsViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Public REST API — Posts')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(child: _buildBody(vm)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => vm.loadPosts(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reload'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody(PostsViewModel vm) {
    switch (vm.state) {
      case ViewState.busy:
        return const Center(child: CircularProgressIndicator());
      case ViewState.empty:
        return _buildEmpty();
      case ViewState.error:
        return _buildError(vm.message ?? 'Unknown error');
      case ViewState.idle:
      default:
        return _buildList(vm.posts);
    }
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          SizedBox(height: 8),
          Text('No posts found', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 8),
          Text('Error: \$message', textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildList(List<Post> posts) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<PostsViewModel>(context, listen: false).loadPosts();
      },
      child: ListView.separated(
        separatorBuilder: (_, __) => const Divider(),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final p = posts[index];
          return ListTile(
            title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(p.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            leading: CircleAvatar(child: Text(p.id.toString())),
          );
        },
      ),
    );
  }
}
