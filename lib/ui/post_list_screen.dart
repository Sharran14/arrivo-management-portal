import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/post_bloc.dart';
import '../blocs/post_state.dart';

class PostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Posts'),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return Card(
                  child: ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body),
                  ),
                );
              },
            );
          } else if (state is PostError) {
            return Center(child: Text('Failed to load posts'));
          }
          return Container();
        },
      ),
    );
  }
}
