import 'package:equatable/equatable.dart';

abstract class ToothEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchTooth extends ToothEvent {}
