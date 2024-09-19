import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}
// This event is dispatched when load posts from an API
class LoadPosts extends PostEvent {}

//PostEvent defines the trigger like fetching data from API. Each event
//is handled by PostBloc

//LoadPosts represents the event to load data from the API, triggers the loading state in PostBloc
