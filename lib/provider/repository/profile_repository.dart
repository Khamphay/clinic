import 'package:clinic/model/profile_model.dart';

class ProfileRepository {
  Future<List<ProfileModel>> fetchProfile() async {
    return await ProfileModel.fetchAllUser();
  }
}
