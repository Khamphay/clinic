import 'package:clinic/model/promotion_model.dart';

class PromotionRepository {
  Future<List<PromotionModel>> fetchPromotion() async {
    return await PromotionModel.fetchPromotion();
  }
}
