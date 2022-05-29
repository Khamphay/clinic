import 'package:clinic/model/reserve_model.dart';

class NotificationRepository {
  Future<ReserveModel?> fetchAdminReserveNotification() async {
    // return ReserveModel.fetchAdminReserveNotification();
  }

  Future<ReserveModel?> fetchMemberReserveNotification() async {
    return ReserveModel.fetchMemberReserveNotification();
  }
}
