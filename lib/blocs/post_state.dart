import 'package:equatable/equatable.dart';
import '../models/post_model.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

// Represents the loading state of posts
class PostLoading extends PostState {}

// Represents the loaded state of posts
class PostLoaded extends PostState {
  final List<Post> posts;
  
  // Takes the list of posts as a parameter
  const PostLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}
// Represents an error state when loading posts
class PostError extends PostState {}
