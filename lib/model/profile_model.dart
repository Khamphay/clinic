import 'dart:convert';
import 'package:clinic/model/district_model.dart';
import 'package:clinic/model/province_model.dart';
import 'package:clinic/model/respone_model.dart';
import 'package:clinic/model/roles_model.dart';
import 'package:clinic/source/exception.dart';
import 'package:clinic/source/source.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';

class ProfileModel {
  final int? id;
  final int provinceId;
  final ProvinceModel? province;
  final int districtId;
  final DistrictModel? district;
  final String userId;
  final String firstname;
  final String lastname;
  final String gender;
  final String birthDate;
  final String phone;
  final String? password;
  final String? isDelete;
  final String? image;
  final File? file;
  final String village;
  final List<RolesModel> roles;
  ProfileModel(
      {this.id,
      required this.provinceId,
      this.province,
      required this.districtId,
      this.district,
      required this.village,
      required this.userId,
      required this.firstname,
      required this.lastname,
      required this.gender,
      this.password,
      required this.birthDate,
      required this.phone,
      this.isDelete,
      this.image,
      this.file,
      required this.roles});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'firstname': firstname,
      'lastname': lastname,
      'gender': gender,
      'birthDate': birthDate,
      'isDelete': isDelete,
      'phone': image,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id']?.toInt(),
      userId: map['userId'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: map['birthDate'] ?? '',
      isDelete: map['isDelete'] ?? '',
      phone: map['phone'] ?? '',
      image: map['image'] ?? '',
      districtId: map['districtId'] ?? 0,
      district: map['District'] != null
          ? DistrictModel.fromMap(map['District'])
          : null,
      provinceId: map['provinceId'] ?? 0,
      province: map['Province'] != null
          ? ProvinceModel.fromMap(map['Province'])
          : null,
      roles: map['roles'] != null
          ? List<RolesModel>.from(
              map['roles'].map((role) => RolesModel.fromMap(role)))
          : [],
      village: map['village'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));

  static Future<ResponseModel> registerMember(
      {required ProfileModel data}) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse(url + '/admin/users'));

      request.headers
          .addAll({'Authorization': token, 'Content-Type': 'application/json'});
      request.fields['id'] = '${data.id}';
      request.fields['userId'] = data.userId;
      request.fields['firstname'] = data.firstname;
      request.fields['lastname'] = data.lastname;
      request.fields['gender'] = data.gender;
      request.fields['birthDate'] = data.birthDate;
      request.fields['provinceId'] = '${data.provinceId}';
      request.fields['districtId'] = '${data.districtId}';
      request.fields['village'] = data.village;
      request.fields['password'] = data.password ?? '';
      request.fields['phone'] = data.phone;

      for (int i = 0; i < data.roles.length; i++) {
        request.fields['roles[$i]'] = '${data.roles[i].id}';
      }

      if (data.file != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'photo', data.file?.path ?? '',
            contentType: MediaType('image', 'png')));
      }

      final response = await request.send();

      final post = await http.Response.fromStream(response);
      if (post.statusCode == 201) {
        return ResponseModel.fromJson(source: post.body, code: post.statusCode);
      } else {
        throw BadRequestException(error: post.body);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> editUser({required ProfileModel data}) async {
    try {
      final request = http.MultipartRequest('PUT', Uri.parse(url + '/users'));

      request.headers
          .addAll({'Authorization': token, 'Content-Type': 'application/json'});
      request.fields['id'] = '${data.id}';
      request.fields['userId'] = data.userId;
      request.fields['firstname'] = data.firstname;
      request.fields['lastname'] = data.lastname;
      request.fields['gender'] = data.gender;
      request.fields['birthDate'] = data.birthDate;
      request.fields['provinceId'] = '${data.provinceId}';
      request.fields['districtId'] = '${data.districtId}';
      request.fields['village'] = data.village;
      request.fields['phone'] = data.phone;

      for (int i = 0; i < data.roles.length; i++) {
        request.fields['roles[$i]'] = '${data.roles[i].id}';
      }

      if (data.file != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'photo', data.file?.path ?? '',
            contentType: MediaType('image', 'png')));
      }

      final response = await request.send();

      final put = await http.Response.fromStream(response);
      if (put.statusCode == 200) {
        return ResponseModel.fromJson(source: put.body, code: put.statusCode);
      } else {
        throw BadRequestException(error: put.body);
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

class ReserveDetails {
  final int? id;
  final int reserveId;
  final String date;
  final String detail;
  final String isStatus;
  ReserveDetails({
    this.id,
    required this.reserveId,
    required this.date,
    required this.detail,
    required this.isStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reserveId': reserveId,
      'date': date,
      'detail': detail,
      'isStatus': isStatus,
    };
  }

  factory ReserveDetails.fromMap(Map<String, dynamic> map) {
    return ReserveDetails(
      id: map['id']?.toInt(),
      reserveId: map['reserveId']?.toInt() ?? 0,
      date: map['date'] ?? '',
      detail: map['detail'] ?? '',
      isStatus: map['isStatus'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReserveDetails.fromJson(String source) =>
      ReserveDetails.fromMap(json.decode(source));
}
