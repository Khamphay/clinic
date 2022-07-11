import 'package:clinic/model/reserve_model.dart';

class NotificationRepository {
  Future<List<ReserveModel>> fetchAdminReserveNotification() async {
    return ReserveModel.fetchAllReserveNotification();
  }

  Future<List<ReserveModel>> fetchAdminReserveCancelNotification() async {
    return ReserveModel.fetchAllReserveCancelNotification();
  }

  Future<List<ReserveModel>> fetchMemberReserveNotification() async {
    return ReserveModel.fetchMemberReserveNotification();
  }

  Future<List<ReserveModel>> fetcCancelhMemberReserveNotification() async {
    return ReserveModel.fetchCancelMemberReserveNotification();
  }
}
