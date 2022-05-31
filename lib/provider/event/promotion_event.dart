import 'package:equatable/equatable.dart';

abstract class PromotionEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchPromotion extends PromotionEvent {}

class FetchCustomerPromotion extends PromotionEvent {}
