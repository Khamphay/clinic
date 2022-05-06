import 'package:equatable/equatable.dart';

import 'package:clinic/model/tooth_model.dart';

abstract class ToothState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToothInitialState extends ToothState {}

class ToothLoadingState extends ToothState {}

class ToothLoadCompleteState extends ToothState {
  final List<ToothModel> tooths;
  ToothLoadCompleteState({
    required this.tooths,
  });
}

class ToothErrorState extends ToothState {
  final String error;
  ToothErrorState({
    required this.error,
  });
}
