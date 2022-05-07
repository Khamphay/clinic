import 'package:clinic/provider/event/tooth_event.dart';
import 'package:clinic/provider/repository/tooth_repository.dart';
import 'package:clinic/provider/state/tooth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToothBloc extends Bloc<ToothEvent, ToothState> {
  final ToothRepository toothRepo;
  ToothBloc({required this.toothRepo}) : super(ToothInitialState()) {
    on<FetchTooth>((event, emit) async {
      emit(ToothLoadingState());

      try {
        final tooths = await toothRepo.fetchTooth();
        emit(ToothLoadCompleteState(tooths: tooths));
      } on Exception catch (e) {
        emit(ToothErrorState(error: e.toString()));
      }
    });
  }
}
