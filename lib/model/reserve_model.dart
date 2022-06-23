import 'dart:convert';
import 'dart:io';

import 'package:clinic/model/reserve_detail_model.dart';
import 'package:clinic/notification/socket/socket_controller.dart';
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
  final String date;
  final String startDate;
  final String? endDate;
  final String? updatedAt;
  final String detail;
  final int? promotionId;
  double price;
  final double detailPrice;
  final double discountPrice;
  final String? isStatus;
  final String? description;
  final UserModel? user;
  final PromotionModel? promotion;
  final ToothModel? tooth;
  final List<ReserveDetailModel>? reserveDetail;
  ReserveModel(
      {this.id,
      required this.toothId,
      required this.startDate,
      this.endDate,
      required this.date,
      required this.detail,
      this.promotionId,
      required this.price,
      required this.detailPrice,
      required this.discountPrice,
      this.isStatus,
      this.description,
      this.updatedAt,
      this.user,
      this.promotion,
      this.tooth,
      this.reserveDetail});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'toothId': toothId,
      'startDate': startDate,
      'date': date,
      'price': price,
      'discountPrice': discountPrice,
      'detailPrice': detailPrice,
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
      discountPrice: map['price']?.toDouble() ?? 0,
      detailPrice: map['price']?.toDouble() ?? 0,
      date: map['date'] ?? '',
      isStatus: map['isStatus'] ?? '',
      updatedAt: map['updatedAt'] ?? DateTime.now().toString(),
      description: map['description'] ?? '',
      user: map['User'] != null ? UserModel.fromMap(map['User']) : null,
      promotion: map['Promotion'] != null
          ? PromotionModel.fromMap(map['Promotion'])
          : null,
      tooth: map['Tooth'] != null ? ToothModel.fromMap(map['Tooth']) : null,
      reserveDetail: map['ReserveDetails'] != null
          ? List<ReserveDetailModel>.from(
              map['ReserveDetails']?.map((x) => ReserveDetailModel.fromMap(x)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReserveModel.fromJson(String source) =>
      ReserveModel.fromMap(json.decode(source)['reserve']);

  static Future<List<ReserveModel>> fetchAllReserve(
      {String? status, String? start, String? end}) async {
    try {
      String query =
          (start != null && end != null) ? '&start=$start&end=$end' : '';
      final response = await http.get(
          Uri.parse(url + '/reserves?status=$status$query'),
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

  static Future<List<ReserveModel>> fetchMemberReserve(
      {String? status, String? start, String? end}) async {
    try {
      final response = await http.get(
          Uri.parse(url +
              '/reserves/getUserReserve?status=$status&start=$start&end=$end'),
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

  static Future<List<ReserveModel>> fetchMemberReserveNotification() async {
    try {
      final response = await http.get(Uri.parse(url + '/reserves/user'),
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        return json
            .decode(response.body)['reserve']
            .cast<Map<String, dynamic>>()
            .map<ReserveModel>((map) => ReserveModel.fromMap(map))
            .toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw FetchDataException(error: response.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }

  static Future<List<ReserveModel>>
      fetchCancelMemberReserveNotification() async {
    try {
      final response = await http.get(Uri.parse(url + '/reserves/user/cancel'),
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json'
          });
      if (response.statusCode == 200) {
        return json
            .decode(response.body)['reserve']
            .cast<Map<String, dynamic>>()
            .map<ReserveModel>((map) => ReserveModel.fromMap(map))
            .toList();
      } else if (response.statusCode == 404) {
        return [];
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
        SocketController.sendNotification('notifi', "Add new reserve");
        return ResponseModel.fromJson(source: post.body, code: post.statusCode);
      } else {
        throw FetchDataException(error: post.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }

  static Future<ResponseModel> payReserve(
      {required int reserveId,
      required double payPrice,
      required double total,
      required List<ReserveDetailModel> details}) async {
    try {
      final paid = await http.put(Uri.parse(url + '/reserves'),
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: jsonEncode({
            "reserveId": reserveId,
            "price": payPrice,
            'total': total,
            "details": details.map((e) => e.toMap()).toList()
          }));
      if (paid.statusCode == 200) {
        SocketController.sendNotification('notifi', "Paid reserve");
        return ResponseModel.fromJson(source: paid.body, code: paid.statusCode);
      } else {
        throw FetchDataException(error: paid.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }

  static Future<ResponseModel> cancelReserve(
      {required int reserveId, required String description}) async {
    try {
      final post = await http.put(
          Uri.parse(url + '/reserves/cancel/$reserveId'),
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: jsonEncode({'description': description}));
      if (post.statusCode == 200) {
        SocketController.sendNotification('notifi', "Cancel reserve");
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
        SocketController.sendNotification('notifi', "Delete reserve");
        return ResponseModel.fromJson(source: post.body, code: post.statusCode);
      } else {
        throw FetchDataException(error: post.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }
}
