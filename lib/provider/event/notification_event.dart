import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchAllNotification extends NotificationEvent {}

class FetchMemberNotification extends NotificationEvent {}

// class FetchMemberNotificationextends NotificationEvent {}
