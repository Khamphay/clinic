import 'package:clinic/model/reserve_model.dart';

class ReserveRepository {
  Future<List<ReserveModel>> fetchAllReserve({String? status}) async {
    return ReserveModel.fetchAllReserve(status: status);
  }

  Future<List<ReserveModel>> fetchMemberReserve({String? status}) async {
    return ReserveModel.fetchMemberReserve(status: status);
  }
}
