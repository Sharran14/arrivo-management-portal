import 'package:arrivo_management_portal/blocs/post_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/post_bloc.dart';
import 'services/post_service.dart';
import 'ui/post_list_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => PostBloc(postService: PostService())..add(LoadPosts()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arrivo Management Portal',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PostListScreen(),
    );
  }
}
