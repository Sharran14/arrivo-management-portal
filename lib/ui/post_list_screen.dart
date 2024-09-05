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
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 20, // Adjust column spacing if needed
                  columns: [
                    DataColumn(label: Text('User ID')),
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Body')),
                  ],
                  rows: state.posts.map((post) {
                    return DataRow(cells: [
                      DataCell(
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12), // Adjust row height with padding
                          child: Text(post.id.toString()),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12), // Adjust row height with padding
                          child: Text(post.id.toString()),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12), // Adjust row height with padding
                          child: Text(
                            post.title,
                            maxLines: 2, // Display title on multiple lines if needed
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12), // Adjust row height with padding
                          child: Text(
                            post.body,
                            maxLines: 3, // Display body on multiple lines if needed
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
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
