import 'dart:convert';
import 'dart:io';
import 'package:clinic/model/reserve_model.dart';
import 'package:clinic/model/respone_model.dart';
import 'package:clinic/notification/socket/socket_controller.dart';
import 'package:clinic/source/exception.dart';
import 'package:clinic/source/source.dart';
import 'package:http/http.dart' as http;

class ReserveDetailModel {
  final int? id;
  final int reserveId;
  final double price;
  final double? detailPrice;
  final double? discountPrice;
  final String detail;
  final String? isStatus;
  final String date;
  ReserveDetailModel(
      {this.id,
      required this.reserveId,
      required this.price,
      this.discountPrice,
      this.detailPrice,
      required this.detail,
      this.isStatus,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reserveId': reserveId,
      'price': price,
      'discountPrice': discountPrice,
      'detailPrice': detailPrice,
      'detail': detail,
      'date': date,
      'isStatus': isStatus,
    };
  }

  factory ReserveDetailModel.fromMap(Map<String, dynamic> map) {
    return ReserveDetailModel(
      id: map['id']?.toInt(),
      reserveId: map['reserveId']?.toInt() ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      detail: map['detail'] ?? '',
      date: map['date'] ?? '',
      isStatus: map['isStatus'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReserveDetailModel.fromJson(String source) =>
      ReserveDetailModel.fromMap(json.decode(source));

  static Future<ReserveModel> fetchReserveDetail(
      {required int reserveId}) async {
    try {
      final data = await http.put(Uri.parse(url + '/reserve/$reserveId'),
          headers: {'Authorization': token});
      if (data.statusCode == 200) {
        return ReserveModel.fromJson(data.body);
      } else {
        throw FetchDataException(error: data.body);
      }
    } on SocketException catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> paidReserveDetail(
      {required int detailId}) async {
    try {
      final post = await http.put(Uri.parse(url + '/reserves/$detailId'),
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

  static Future<ResponseModel> postNextReserve(
      {required ReserveDetailModel data}) async {
    try {
      final post = await http.post(Uri.parse(url + '/reserves/new'),
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: data.toJson());
      if (post.statusCode == 201) {
        SocketController.sendNotification('notifi', "Next reserve");
        return ResponseModel.fromJson(source: post.body, code: post.statusCode);
      } else {
        throw FetchDataException(error: post.body);
      }
    } on SocketException catch (e) {
      throw BadRequestException(error: e.toString());
    }
  }
}
