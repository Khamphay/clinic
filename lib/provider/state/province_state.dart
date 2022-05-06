import 'package:equatable/equatable.dart';

import 'package:clinic/model/province_model.dart';

abstract class ProvinceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProvinceInitialState extends ProvinceState {}

class ProvinceLoadingState extends ProvinceState {}

class ProvinceLoadCompleteState extends ProvinceState {
  final List<ProvinceModel> provinces;
  ProvinceLoadCompleteState({
    required this.provinces,
  });
}

class ProvinceErrorState extends ProvinceState {
  final String error;
  ProvinceErrorState({
    required this.error,
  });
}
