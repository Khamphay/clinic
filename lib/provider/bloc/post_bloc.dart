import 'package:clinic/provider/event/post_event.dart';
import 'package:clinic/provider/repository/post_repository.dart';
import 'package:clinic/provider/state/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepo;
  PostBloc({required this.postRepo}) : super(PostInitialState()) {
    on<FetchPost>((event, emit) async {
      emit(PostLoadingState());

      try {
        final posts = await postRepo.fetchPost();
        emit(PostLoadCompleteState(posts: posts));
      } on Exception catch (e) {
        emit(PostErrorState(error: e.toString()));
      }
    });
  }
}
