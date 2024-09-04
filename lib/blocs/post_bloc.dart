// ignore_for_file: override_on_non_overriding_member

import 'package:arrivo_management_portal/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService postService;

  PostBloc({required this.postService}) : super(PostLoading());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is LoadPosts) {
      yield PostLoading();
      try {
        final posts = await postService.fetchPosts();
        yield PostLoaded(posts);
      } catch (_) {
        yield PostError();
      }
    }
  }
}

