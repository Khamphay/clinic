import 'package:clinic/model/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
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

class EmployeeLoadingState extends UserState {}

class EmployeeLoadCompleteState extends UserState {
  final List<UserModel> employees;

  EmployeeLoadCompleteState({
    required this.employees,
  });
}

class EmployeeErrorState extends UserState {
  final String error;
  EmployeeErrorState({
    required this.error,
  });
}

class CustomerLoadingState extends UserState {}

class CustomerLoadCompleteState extends UserState {
  final List<UserModel> customers;

  CustomerLoadCompleteState({
    required this.customers,
  });
}

class CustomerErrorState extends UserState {
  final String error;
  CustomerErrorState({
    required this.error,
  });
}
