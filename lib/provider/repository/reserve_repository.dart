import 'package:clinic/model/reserve_model.dart';

class ReserveRepository {
  Future<List<ReserveModel>> fetchAllReserve() async {
    return ReserveModel.fetchAllReserve();
  }

  Future<List<ReserveModel>> fetchMemberReserve() async {
    return ReserveModel.fetchMemberReserve();
  }
}
