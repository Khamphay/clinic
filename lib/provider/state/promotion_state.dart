import 'package:equatable/equatable.dart';

import 'package:clinic/model/promotion_model.dart';

abstract class PromotionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PromotionInitialState extends PromotionState {}

class PromotionLoadingState extends PromotionState {}

class PromotionLoadCompleteState extends PromotionState {
  final List<PromotionModel> promotions;
  PromotionLoadCompleteState({
    required this.promotions,
  });
}

class PromotionErrorState extends PromotionState {
  final String error;
  PromotionErrorState({
    required this.error,
  });
}
