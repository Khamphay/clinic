import 'package:equatable/equatable.dart';

import 'package:clinic/model/post_model.dart';

abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostLoadCompleteState extends PostState {
  final List<PostModel> posts;
  PostLoadCompleteState({
    required this.posts,
  });
}

class PostErrorState extends PostState {
  final String error;
  PostErrorState({
    required this.error,
  });
}
