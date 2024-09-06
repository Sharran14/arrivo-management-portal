import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}
// This event is dispatched when load posts from an API
class LoadPosts extends PostEvent {}
