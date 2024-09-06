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
  int _currentPage = 1;
  int _rowsPerPage = 10;
  List<int> _rowsPerPageOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Set background color here
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
                              _currentPage = 1; // Reset to the first page
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
                            _currentPage = 1; // Reset to the first page
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

                      // Pagination logic with clamp to prevent RangeError
                      final start = ((_currentPage - 1) * _rowsPerPage).clamp(0, filteredPosts.length);
                      final end = (start + _rowsPerPage).clamp(start, filteredPosts.length);
                      final displayedPosts = filteredPosts.sublist(start, end);

                      return Column(
                        children: [
                          // Make the table scrollable horizontally
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical, // Enable vertical scrolling
                                child: DataTable(
                                  columnSpacing: 20,
                                  columns: [
                                    DataColumn(
                                      label: Container(
                                        alignment: Alignment.center, // Center-align header
                                        padding: EdgeInsets.all(8.0), // Padding inside the header
                                        child: Text(
                                          'User ID',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center, // Center text inside the header
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'ID',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Title',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Body',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: displayedPosts.map((post) {
                                    return DataRow(
                                      color: WidgetStateProperty.all<Color>(Colors.white), // White background for rows
                                      cells: [
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
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          // Pagination controls at the bottom right
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomRight, // Aligns pagination to the bottom right
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end, // Aligns row contents to the end (right)
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    onPressed: _currentPage > 1
                                        ? () {
                                            setState(() {
                                              _currentPage--;
                                            });
                                          }
                                        : null,
                                  ),
                                  for (int i = 1; i <= (filteredPosts.length / _rowsPerPage).ceil(); i++) ...[
                                    if (i == 1 || i == (filteredPosts.length / _rowsPerPage).ceil() || (i >= _currentPage - 1 && i <= _currentPage + 1))
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _currentPage = i;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          margin: EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(
                                            color: _currentPage == i ? Colors.purple : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '$i',
                                            style: TextStyle(
                                              color: _currentPage == i ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (i == _currentPage - 2 || i == _currentPage + 2)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text("..."),
                                      ),
                                  ],
                                  IconButton(
                                    icon: Icon(Icons.arrow_forward_ios),
                                    onPressed: _currentPage < (filteredPosts.length / _rowsPerPage).ceil()
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
                          ),
                        ],
                      );
                    } else if (state is PostError) {
                      return Center(child: Text('Failed to load posts'));
                    } else {
                      return Container(); // Empty container for other states
                    }
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
