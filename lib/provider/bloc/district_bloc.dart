import 'package:clinic/model/district_model.dart';
import 'package:clinic/provider/event/district_event.dart';
import 'package:clinic/provider/repository/district_repository.dart';
import 'package:clinic/provider/state/district_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DistrictBloc extends Bloc<DistrictEvent, DistrictState> {
  final DistrictRepository districtRepo;
  DistrictBloc({required this.districtRepo}) : super(DistrictInitialState()) {
    on<FetchDistrict>((event, emit) async {
      emit(DistrictLoadingState());

      try {
        final districts =
            await districtRepo.fetchDistrict(provinceId: event.provinceId);
        emit(DistrictLoadCompleteState(districts: districts));
      } on Exception catch (e) {
        emit(DistrictErrorState(error: e.toString()));
      }
    });
  }
}
