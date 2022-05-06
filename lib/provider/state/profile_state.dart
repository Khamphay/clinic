import 'package:equatable/equatable.dart';

import 'package:clinic/model/profile_model.dart';

abstract class  ProfileState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ProfileInitialState extends  ProfileState {}

class  ProfileLoadingState extends  ProfileState {}

class  ProfileLoadCompletedState extends  ProfileState {
  final List<ProfileModel> customers;

   ProfileLoadCompletedState({
    required this.customers,
  });
}

class  ProfileErrorState extends  ProfileState {
  final String error;
   ProfileErrorState({
    required this.error,
  });
}
