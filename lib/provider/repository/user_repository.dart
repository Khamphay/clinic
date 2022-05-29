import 'package:clinic/model/user_model.dart';

class UserRepository {
  Future<List<UserModel>> fetchAllUser() async {
    return await UserModel.fetchAllUser();
  }

  Future<List<UserModel>> fetchEmployee() async {
    return await UserModel.fetchEmployee();
  }

  Future<List<UserModel>> fetchCustomer() async {
    return await UserModel.fetchCustomer();
  }
}
