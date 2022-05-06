import 'dart:convert';
import 'package:clinic/model/respone_model.dart';
import 'package:clinic/source/exception.dart';
import 'package:clinic/source/source.dart';
import 'package:http/http.dart' as http;

class ProvinceModel {
  final int? id;
  final String name;
  final String section;
  String? isDelete;
  ProvinceModel({
    this.id,
    required this.name,
    required this.section,
    this.isDelete,
  });

  Map<String, dynamic> toMap() {
    return {
      'provinceId': id,
      'name': name,
      'section': section,
      'isDelete': isDelete,
    };
  }

  factory ProvinceModel.fromMap(Map<String, dynamic> map) {
    return ProvinceModel(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      section: map['section'] ?? '',
      isDelete: map['isDelete'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvinceModel.fromJson(String source) =>
      ProvinceModel.fromMap(json.decode(source));

  static Future<List<ProvinceModel>> fetchProvince() async {
    try {
      final response = await http.get(Uri.parse(url + '/provinces'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return json
            .decode(response.body)['provinces']
            .cast<Map<String, dynamic>>()
            .map<ProvinceModel>((data) => ProvinceModel.fromMap(data))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> postProvince(
      {required ProvinceModel data}) async {
    try {
      final response = await http.post(Uri.parse(url + '/provinces'),
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

  static Future<ResponseModel> putProvince(
      {required ProvinceModel data}) async {
    try {
      final response = await http.put(Uri.parse(url + '/provinces'),
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

  static Future<ResponseModel> deleteProvince(
      {required ProvinceModel data}) async {
    try {
      final response = await http.post(Uri.parse(url + '/provinces/delete'),
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
