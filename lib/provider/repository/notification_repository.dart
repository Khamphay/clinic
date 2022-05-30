import 'package:clinic/model/reserve_model.dart';

class NotificationRepository {
  Future<List<ReserveModel>> fetchAdminReserveNotification() async {
    return ReserveModel.fetchAllReserveNotification();
  }

  Future<ReserveModel?> fetchMemberReserveNotification() async {
    return ReserveModel.fetchMemberReserveNotification();
  }
}
