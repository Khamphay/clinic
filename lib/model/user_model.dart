import 'dart:convert';
import 'dart:io';

import 'package:clinic/model/profile_model.dart';
import 'package:clinic/model/respone_model.dart';
import 'package:clinic/model/roles_model.dart';
import 'package:clinic/source/exception.dart';
import 'package:clinic/source/source.dart';
import 'package:http/http.dart' as http;

class UserModel {
  final String? id;
  final String phone;
  final String password;
  final String? isDelete;
  final ProfileModel profile;
  final List<RolesModel> roles;
  UserModel({
    this.id,
    required this.phone,
    required this.password,
    this.isDelete,
    required this.profile,
    required this.roles,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'password': password,
      'isDelete': isDelete,
      'profile': profile.toMap(),
      'roles': roles.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      isDelete: map['isDelete'],
      profile: ProfileModel.fromMap(map['Profile']),
      roles: map['roles'] != null
          ? List<RolesModel>.from(
              map['roles']?.map((x) => RolesModel.fromMap(x)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source)['user']);

  static Future<List<UserModel>> fetchAllUser() async {
    try {
      final response = await http.get(Uri.parse(url + '/admin/users'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['users']
            .cast<Map<String, dynamic>>()
            .map<UserModel>((map) => UserModel.fromMap(map))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on SocketException {
      throw 'ບໍ່ສາມາດເຊື່ອຕໍ່ Server';
    }
  }

  static Future<List<UserModel>> fetchEmployee() async {
    try {
      final response = await http.get(Uri.parse(url + '/admin/users/employee'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['users']
            .cast<Map<String, dynamic>>()
            .map<UserModel>((map) => UserModel.fromMap(map))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on SocketException {
      throw 'ບໍ່ສາມາດເຊື່ອຕໍ່ Server';
    }
  }

  static Future<List<UserModel>> fetchCustomer() async {
    try {
      final response = await http.get(Uri.parse(url + '/admin/users/customer'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['users']
            .cast<Map<String, dynamic>>()
            .map<UserModel>((map) => UserModel.fromMap(map))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on SocketException {
      throw 'ບໍ່ສາມາດເຊື່ອຕໍ່ Server';
    }
  }

  static Future<UserModel> fetchUser({required String userId}) async {
    try {
      final response = await http.get(Uri.parse(url + '/admin/users/$userId'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.body);
      } else {
        throw FetchDataException(error: response.body);
      }
    } on SocketException {
      throw 'ບໍ່ສາມາດເຊື່ອຕໍ່ Server';
    }
  }

  static Future<ResponseModel> deleteUser({required UserModel user}) async {
    try {
      final response = await http.post(Uri.parse(url + '/admin/users/delete'),
          headers: {'Authorization': token},
          body: {"userId": user.id, "phone": user.phone});
      if (response.statusCode == 200) {
        return ResponseModel.fromJson(
            source: response.body, code: response.statusCode);
      } else {
        throw FetchDataException(error: response.body);
      }
    } on SocketException {
      throw 'ບໍ່ສາມາດເຊື່ອຕໍ່ Server';
    }
  }
}
