import 'package:arrivo_management_portal/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_event.dart';
import 'post_state.dart';

//Managing Events and State Changes
class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService postService;

  PostBloc({required this.postService}) : super(PostLoading()) {
    // Register the event handler
    on<LoadPosts>(_onLoadPosts);
  }

  // Event handler for LoadPosts
  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final posts = await postService.fetchPosts();
      emit(PostLoaded(posts));
    } catch (_) {
      emit(PostError());
    }
  }
}
