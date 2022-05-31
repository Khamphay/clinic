import 'package:clinic/model/reserve_model.dart';

class ReserveRepository {
  Future<List<ReserveModel>> fetchAllReserve(
      {String? status, String? start, String? end}) async {
    return ReserveModel.fetchAllReserve(status: status, start: start, end: end);
  }

  Future<List<ReserveModel>> fetchMemberReserve(
      {String? status, String? start, String? end}) async {
    return ReserveModel.fetchMemberReserve(
        status: status, start: start, end: end);
  }
}
