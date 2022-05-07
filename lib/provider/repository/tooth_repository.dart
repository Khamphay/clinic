import 'package:clinic/model/tooth_model.dart';

class ToothRepository {
  Future<List<ToothModel>> fetchTooth() async {
    return await ToothModel.fetchTooth();
  }
}
