import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/post_bloc.dart';
import '../blocs/post_state.dart';

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  int _currentPage = 0;
  int _rowsPerPage = 10;
  List<int> _rowsPerPageOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Set your background color here
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the white layer
        child: Container(
          padding: const EdgeInsets.all(16.0), // Padding inside the white layer
          decoration: BoxDecoration(
            color: Colors.white, // White layer background
            borderRadius: BorderRadius.circular(8), // Rounded corners for white layer
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4), // Shadow for elevation effect
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add a row for "Blog Posts" text
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Blog Posts',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Row for "Show entries" and Search Box
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Show entries dropdown
                    Row(
                      children: [
                        Text("Show "),
                        DropdownButton<int>(
                          value: _rowsPerPage,
                          items: _rowsPerPageOptions.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _rowsPerPage = newValue!;
                              _currentPage = 0;
                            });
                          },
                        ),
                        Text(" entries"),
                      ],
                    ),
                    // Search box
                    Container(
                      width: 250, // Adjust width to make the search box smaller
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchText = value.toLowerCase();
                            _currentPage = 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if (state is PostLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is PostLoaded) {
                      // Filter the posts based on the search query
                      final filteredPosts = state.posts.where((post) {
                        return post.id.toString().contains(_searchText) ||
                               post.title.toLowerCase().contains(_searchText) ||
                               post.body.toLowerCase().contains(_searchText);
                      }).toList();

                      // Pagination logic
                      final totalPages = (filteredPosts.length / _rowsPerPage).ceil();
                      final start = _currentPage * _rowsPerPage;
                      final end = start + _rowsPerPage;
                      final displayedPosts = filteredPosts.sublist(
                          start, end > filteredPosts.length ? filteredPosts.length : end);

                      return Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: DataTable(
                                columnSpacing: 20,
                                columns: [
                                  DataColumn(
                                    label: Container(
                                      width: 200,
                                      child: Text('User ID'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Container(
                                      width: 200,
                                      child: Text('ID'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Container(
                                      width: 500,
                                      child: Text('Title'),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Container(
                                      width: 500,
                                      child: Text('Body'),
                                    ),
                                  ),
                                ],
                                rows: displayedPosts.map((post) {
                                  return DataRow(cells: [
                                    DataCell(
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                        child: SizedBox(
                                          width: 200,
                                          child: Text(post.id.toString()),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                        child: SizedBox(
                                          width: 200,
                                          child: Text(post.id.toString()),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                        child: SizedBox(
                                          width: 500,
                                          child: Text(
                                            post.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                        child: SizedBox(
                                          width: 500,
                                          child: Text(
                                            post.body,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                          // Pagination controls
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: _currentPage > 0
                                      ? () {
                                          setState(() {
                                            _currentPage--;
                                          });
                                        }
                                      : null,
                                ),
                                Text("Page ${_currentPage + 1} of $totalPages"),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: _currentPage < totalPages - 1
                                      ? () {
                                          setState(() {
                                            _currentPage++;
                                          });
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (state is PostError) {
                      return Center(child: Text('Failed to load posts'));
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
