import 'dart:convert';

import 'dart:io';
import 'package:clinic/notification/socket/socket_controller.dart';
import 'package:clinic/source/exception.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:clinic/model/respone_model.dart';
import 'package:clinic/source/source.dart';

class PromotionModel {
  final int? id;
  final String name;
  final String detail;
  final String? image;
  final String start;
  final String end;
  final int discount;
  final String? isDelete;
  final File? file;
  PromotionModel({
    this.id,
    required this.name,
    required this.detail,
    this.image,
    required this.start,
    required this.end,
    required this.discount,
    this.file,
    this.isDelete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'detail': detail,
      'image': image,
      'start': start,
      'end': end,
      'discount': discount,
      'isDelete': isDelete,
    };
  }

  factory PromotionModel.fromMap(Map<String, dynamic> map) {
    return PromotionModel(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      detail: map['detail'] ?? '',
      image: map['image'] ?? '',
      start: map['start'] ?? '',
      end: map['end'] ?? '',
      discount: map['discount']?.toInt(),
      isDelete: map['isDelete'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionModel.fromJson(String source) =>
      PromotionModel.fromMap(json.decode(source));

  static Future<List<PromotionModel>> fetchPromotion() async {
    try {
      final response = await http.get(Uri.parse(url + '/promotions'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['promotion']
            .cast<Map<String, dynamic>>()
            .map<PromotionModel>((data) => PromotionModel.fromMap(data))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  static Future<List<PromotionModel>> fetchCustomerPromotion() async {
    try {
      final response = await http.get(Uri.parse(url + '/promotions/customer'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['promotion']
            .cast<Map<String, dynamic>>()
            .map<PromotionModel>((data) => PromotionModel.fromMap(data))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> postPromotion(
      {required PromotionModel data}) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse(url + '/promotions'));

      request.headers
          .addAll({'Authorization': token, 'Content-Type': 'application/json'});
      request.fields['name'] = data.name;
      request.fields['detail'] = data.detail;
      request.fields['name'] = data.name;
      request.fields['detail'] = data.detail;
      request.fields['discount'] = '${data.discount}';
      request.fields['start'] = data.start;
      request.fields['end'] = data.end;

      if (data.file != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'photo', data.file?.path ?? '',
            contentType: MediaType('image', 'png')));
      }

      final response = await request.send();
      final promotion = await http.Response.fromStream(response);
      if (promotion.statusCode == 201) {
        SocketController.sendNotification('promotion', 'Add promotion');
        return ResponseModel.fromJson(
            source: promotion.body, code: promotion.statusCode);
      } else {
        throw BadRequestException(error: promotion.body);
      }
    } on SocketException catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> putPromotion(
      {required PromotionModel data}) async {
    try {
      final request =
          http.MultipartRequest('PUT', Uri.parse(url + '/promotions'));

      request.headers
          .addAll({'Authorization': token, 'Content-Type': 'application/json'});
      request.fields['promotionId'] = '${data.id}';
      request.fields['name'] = data.name;
      request.fields['detail'] = data.detail;
      request.fields['discount'] = '${data.discount}';
      request.fields['start'] = data.start;
      request.fields['end'] = data.end;

      if (data.file != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'photo', data.file?.path ?? '',
            contentType: MediaType('image', 'png')));
      }

      final response = await request.send();
      final promotion = await http.Response.fromStream(response);
      if (promotion.statusCode == 200) {
        SocketController.sendNotification('promotion', 'Update promotion');
        return ResponseModel.fromJson(
            source: promotion.body, code: promotion.statusCode);
      } else {
        throw BadRequestException(error: promotion.body);
      }
    } on SocketException catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> detelePromotion({required int id}) async {
    try {
      final delete = await http.post(Uri.parse(url + '/promotions/delete/$id'),
          headers: {'Authorization': token});

      if (delete.statusCode == 200) {
        SocketController.sendNotification('promotion', 'Delete promotion');
        return ResponseModel.fromJson(
            source: delete.body, code: delete.statusCode);
      } else {
        throw BadRequestException(error: delete.body);
      }
    } on SocketException catch (e) {
      throw e.toString();
    }
  }
}
