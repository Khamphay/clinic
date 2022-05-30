import 'package:equatable/equatable.dart';

abstract class ReserveEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchAllReserve extends ReserveEvent {
  final String? status;
  FetchAllReserve({this.status});
}

class FetchMemberReserve extends ReserveEvent {
  final String? status;
  FetchMemberReserve({
    this.status,
  });
}
