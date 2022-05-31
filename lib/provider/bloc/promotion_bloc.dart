import 'package:clinic/provider/event/promotion_event.dart';
import 'package:clinic/provider/repository/promotion_repository.dart';
import 'package:clinic/provider/state/promotion_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final PromotionRepository promotionRepo;
  PromotionBloc({required this.promotionRepo})
      : super(PromotionInitialState()) {
    on<FetchPromotion>((event, emit) async {
      emit(PromotionLoadingState());

      try {
        final promotions = await promotionRepo.fetchPromotion();
        emit(PromotionLoadCompleteState(promotions: promotions));
      } on Exception catch (e) {
        emit(PromotionErrorState(error: e.toString()));
      }
    });

    on<FetchCustomerPromotion>((event, emit) async {
      emit(PromotionLoadingState());

      try {
        final promotions = await promotionRepo.fetchCustomerPromotion();
        emit(CustomerPromotionLoadCompleteState(promotions: promotions));
      } on Exception catch (e) {
        emit(PromotionErrorState(error: e.toString()));
      }
    });
  }
}
