import 'package:equatable/equatable.dart';

abstract class DistrictEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchDistrict extends DistrictEvent {
  final int provinceId;
  FetchDistrict({
    required this.provinceId,
  });
}

class FetchAllDistrict extends DistrictEvent {}
