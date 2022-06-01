import 'package:clinic/provider/event/reserve_event.dart';
import 'package:clinic/provider/repository/reserve_repository.dart';
import 'package:clinic/provider/state/reserve_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReserveBloc<ReserveModel> extends Bloc<ReserveEvent, ReserveState> {
  final ReserveRepository reserveRepo;

  ReserveBloc({required this.reserveRepo}) : super(ReserveInitialState()) {
    on<FetchAllReserve>((event, emit) async {
      emit(ReserveLoadingState());

      try {
        final reserves = await reserveRepo.fetchAllReserve(
            status: event.status, start: event.start, end: event.end);
        double total = 0;
        for (int index = 0; index < reserves.length; index++) {
          double sum = 0;
          for (var e in reserves[index].reserveDetail!) {
            sum += e.price;
          }
          reserves[index].price = sum;
          total += sum;
        }
        emit(ReserveLoadCompleteState(reserves: reserves, total: total));
      } on Exception catch (e) {
        emit(ReserveErrorState(error: e.toString()));
      }
    });

    on<FetchMemberReserve>((event, emit) async {
      emit(ReserveLoadingState());

      try {
        final reserves = await reserveRepo.fetchMemberReserve(
            status: event.status, start: event.start, end: event.end);
        emit(ReserveLoadCompleteState(reserves: reserves));
      } on Exception catch (e) {
        emit(ReserveErrorState(error: e.toString()));
      }
    });
  }
}
