import 'package:equatable/equatable.dart';

abstract class ReserveEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchAllReserve extends ReserveEvent {
  final String? status;
  final String? start;
  final String? end;
  FetchAllReserve({
    this.status,
    this.start,
    this.end,
  });
}

class FetchMemberReserve extends ReserveEvent {
  final String? status;
  final String? start;
  final String? end;
  FetchMemberReserve({
    this.status,
    this.start,
    this.end,
  });
}
