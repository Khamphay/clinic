import 'package:equatable/equatable.dart';

import 'package:clinic/model/district_model.dart';

abstract class DistrictState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class DistrictInitailState extends DistrictState {}

class DistrictLoadingState extends DistrictState {}

class DistrictLoadCompledState extends DistrictState {
  final List<DistrictModel> districts;
  DistrictLoadCompledState({
    required this.districts,
  });
}

class DistrictErrorState extends DistrictState {
  final String error;
  DistrictErrorState({
    required this.error,
  });
}
