import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:clinic/model/promotion_model.dart';
import 'package:clinic/model/respone_model.dart';
import 'package:clinic/model/tooth_model.dart';
import 'package:clinic/model/user_model.dart';
import 'package:clinic/source/exception.dart';
import 'package:clinic/source/source.dart';

class ReserveModel {
  final int? id;
  final int toothId;
  final String startDate;
  final String? endDate;
  final String detail;
  final int? promotionId;
  final double price;
  final String? isStatus;
  final UserModel? user;
  final PromotionModel? promotion;
  final ToothModel? tooth;
  ReserveModel({
    this.id,
    required this.toothId,
    required this.startDate,
    this.endDate,
    required this.detail,
    this.promotionId,
    required this.price,
    this.isStatus,
    this.user,
    this.promotion,
    this.tooth,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'toothId': toothId,
      'startDate': startDate,
      'price': price,
      'detail': detail,
      'promotionId': promotionId,
    };
  }

  factory ReserveModel.fromMap(Map<String, dynamic> map) {
    return ReserveModel(
      id: map['id']?.toInt(),
      toothId: map['toothId']?.toInt() ?? 0,
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'],
      detail: map['detail'] ?? '',
      promotionId: map['promotionId']?.toInt(),
      price: map['price']?.toDouble() ?? 0,
      isStatus: map['isStatus'],
      user: map['User'] != null ? UserModel.fromMap(map['User']) : null,
      promotion: map['Promotion'] != null
          ? PromotionModel.fromMap(map['Promotion'])
          : null,
      tooth: map['Tooth'] != null ? ToothModel.fromMap(map['Tooth']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReserveModel.fromJson(String source) =>
      ReserveModel.fromMap(json.decode(source)['reserve']);

  static Future<List<ReserveModel>> fetchAllReserve({String? status}) async {
    try {
      final response = await http.get(
          Uri.parse(url + '/reserves?status=$status'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return json
            .decode(response.body)['reserve']
            .cast<Map<String, dynamic>>()
            .map<ReserveModel>((map) => ReserveModel.fromMap(map))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }

  static Future<List<ReserveModel>> fetchAllReserveNotification() async {
    try {
      final response = await http.get(Uri.parse(url + '/reserves/todayReserve'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return json
            .decode(response.body)['reserve']
            .cast<Map<String, dynamic>>()
            .map<ReserveModel>((map) => ReserveModel.fromMap(map))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }

  static Future<List<ReserveModel>> fetchMemberReserve({String? status}) async {
    try {
      final response = await http.get(
          Uri.parse(url + '/reserves/getUserReserve?status=$status'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return json
            .decode(response.body)['reserve']
            .cast<Map<String, dynamic>>()
            .map<ReserveModel>((map) => ReserveModel.fromMap(map))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }

  static Future<ReserveModel?> fetchMemberReserveNotification() async {
    try {
      final response = await http.get(Uri.parse(url + '/reserves/user'),
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        return ReserveModel.fromJson(response.body);
      } else {
        throw FetchDataException(error: response.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }

  static Future<ResponseModel> postReserve({required ReserveModel data}) async {
    try {
      final post = await http.post(Uri.parse(url + '/reserves'),
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: data.toJson());
      if (post.statusCode == 201) {
        return ResponseModel.fromJson(source: post.body, code: post.statusCode);
      } else {
        throw FetchDataException(error: post.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }

  static Future<ResponseModel> payReserve(
      {required int reserveId, required double payPrice}) async {
    try {
      final paid = await http.put(Uri.parse(url + '/reserves'),
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: jsonEncode({"reserveId": reserveId, "price": payPrice}));
      if (paid.statusCode == 200) {
        return ResponseModel.fromJson(source: paid.body, code: paid.statusCode);
      } else {
        throw FetchDataException(error: paid.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }

  static Future<ResponseModel> cancelReserve({required int reserveId}) async {
    try {
      final post = await http.put(
          Uri.parse(url + '/reserves/cancel/$reserveId'),
          headers: {'Authorization': token});
      if (post.statusCode == 200) {
        return ResponseModel.fromJson(source: post.body, code: post.statusCode);
      } else {
        throw FetchDataException(error: post.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }

  static Future<ResponseModel> deleteReserve({required int reserveId}) async {
    try {
      final post = await http.put(
          Uri.parse(url + '/reserves/cancel/$reserveId'),
          headers: {'Authorization': token});
      if (post.statusCode == 200) {
        return ResponseModel.fromJson(source: post.body, code: post.statusCode);
      } else {
        throw FetchDataException(error: post.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }
}
