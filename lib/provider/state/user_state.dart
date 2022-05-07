import 'package:clinic/model/user_model.dart';
import 'package:equatable/equatable.dart';


abstract class UserState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserLoadCompleteState extends UserState {
  final List<UserModel> users;

  UserLoadCompleteState({
    required this.users,
  });
}

class UserErrorState extends UserState {
  final String error;
  UserErrorState({
    required this.error,
  });
}
