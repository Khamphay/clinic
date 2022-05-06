import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchPost extends PostEvent {}
