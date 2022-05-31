import 'package:equatable/equatable.dart';

import 'package:clinic/model/reserve_model.dart';

abstract class ReserveState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReserveInitialState extends ReserveState {}

class ReserveLoadingState extends ReserveState {}

class ReserveLoadCompleteState extends ReserveState {
  final List<ReserveModel> reserves;
  final double? total;
  ReserveLoadCompleteState({required this.reserves, this.total});
}

class MemberReserveNotifiLoadCompleteState extends ReserveState {
  final ReserveModel? reserve;
  MemberReserveNotifiLoadCompleteState({
    required this.reserve,
  });
}

class ReserveErrorState extends ReserveState {
  final String error;
  ReserveErrorState({
    required this.error,
  });
}
