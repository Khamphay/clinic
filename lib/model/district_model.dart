import 'dart:convert';

import 'package:clinic/model/respone_model.dart';
import 'package:clinic/source/exception.dart';
import 'package:clinic/source/source.dart';
import 'package:http/http.dart' as http;

class DistrictModel {
  final int? id;
  final int provinceId;
  final String name;
  String? isDelete;
  DistrictModel({
    this.id,
    required this.provinceId,
    required this.name,
    this.isDelete,
  });

  Map<String, dynamic> toMap() {
    return {
      'districtId': id,
      'provinceId': provinceId,
      'name': name,
      'isDelete': isDelete,
    };
  }

  factory DistrictModel.fromMap(Map<String, dynamic> map) {
    return DistrictModel(
      id: map['id']?.toInt(),
      provinceId: map['provinceId']?.toInt() ?? 0,
      name: map['name'] ?? '',
      isDelete: map['isDelete'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DistrictModel.fromJson(String source) =>
      DistrictModel.fromMap(json.decode(source));

  static Future<List<DistrictModel>> fetchAllDistrict(
      {required int provinceId}) async {
    try {
      final response = await http.get(Uri.parse(url + '/districts'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['districts']
            .cast<Map<String, dynamic>>()
            .map<DistrictModel>((data) => DistrictModel.fromMap(data))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  static Future<List<DistrictModel>> fetchDistrict(
      {required int provinceId}) async {
    try {
      final response = await http.get(Uri.parse(url + '/districts/$provinceId'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['districts']
            .cast<Map<String, dynamic>>()
            .map<DistrictModel>((data) => DistrictModel.fromMap(data))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> postDistrict(
      {required DistrictModel data}) async {
    try {
      final response = await http.post(Uri.parse(url + '/districts'),
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: data.toJson());
      if (response.statusCode == 201) {
        return ResponseModel.fromJson(
            source: response.body, code: response.statusCode);
      } else {
        throw BadRequestException(error: response.body);
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> putDistrict(
      {required DistrictModel data}) async {
    try {
      final response = await http.put(Uri.parse(url + '/districts'),
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: data.toJson());
      if (response.statusCode == 200) {
        return ResponseModel.fromJson(
            source: response.body, code: response.statusCode);
      } else {
        throw BadRequestException(error: response.body);
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> deleteDistrict(
      {required DistrictModel data}) async {
    try {
      final response = await http.post(Uri.parse(url + '/districts/delete'),
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: data.toJson());
      if (response.statusCode == 200) {
        return ResponseModel.fromJson(
            source: response.body, code: response.statusCode);
      } else {
        throw BadRequestException(error: response.body);
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }
}
