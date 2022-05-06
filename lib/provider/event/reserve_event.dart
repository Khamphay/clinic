import 'package:equatable/equatable.dart';

abstract class ReserveEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchReserve extends ReserveEvent {}
