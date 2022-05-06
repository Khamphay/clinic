import 'package:equatable/equatable.dart';

abstract class ProvinceEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchProvince extends ProvinceEvent {}
