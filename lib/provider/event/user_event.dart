import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUser extends UserEvent {}

class FetchEmployee extends UserEvent {}

class FetchCustomer extends UserEvent {}
