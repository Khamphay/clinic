import 'package:clinic/model/user_model.dart';

class UserRepository {
  Future<List<UserModel>> fetchAllUser() async {
    return await UserModel.fetchAllUser();
  }
}
