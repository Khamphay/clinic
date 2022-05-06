import 'package:clinic/model/district_model.dart';

class DistrictRepository {
  Future<List<DistrictModel>> fetchDistrict({required int provinceId}) async {
    return await DistrictModel.fetchDistrict(provinceId: provinceId);
  }
}
