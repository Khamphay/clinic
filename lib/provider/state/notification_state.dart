import 'package:equatable/equatable.dart';

import 'package:clinic/model/reserve_model.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitialState extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class AllNotificationLoadCompleteState extends NotificationState {
  final List<ReserveModel> reserves;
  AllNotificationLoadCompleteState({required this.reserves});
}

class NotificationLoadCompleteState extends NotificationState {
  final ReserveModel? reserve;
  NotificationLoadCompleteState({required this.reserve});
}

class NotificationErrorState extends NotificationState {
  final String error;
  NotificationErrorState({required this.error});
}
