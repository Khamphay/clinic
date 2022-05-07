import 'dart:convert';
import 'dart:io';
import 'package:clinic/model/respone_model.dart';
import 'package:clinic/source/exception.dart';
import 'package:clinic/source/source.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ToothModel {
  final int? id;
  final String name;
  final double startPrice;
  final String? image;
  final String? isDelete;
  final File? file;
  ToothModel(
      {this.id,
      required this.name,
      required this.startPrice,
      this.image,
      this.isDelete,
      this.file});

  Map<String, dynamic> toMap() {
    return {
      'toothId': id,
      'name': name,
      'startPrice': startPrice,
      'image': image,
      'isDelete': isDelete,
    };
  }

  factory ToothModel.fromMap(Map<String, dynamic> map) {
    return ToothModel(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      startPrice: map['startPrice']?.toDouble() ?? 0.0,
      image: map['image'] ?? '',
      isDelete: map['isDelete'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ToothModel.fromJson(String source) =>
      ToothModel.fromMap(json.decode(source));

  static Future<List<ToothModel>> fetchTooth() async {
    try {
      final response = await http
          .get(Uri.parse(url + '/toothes'), headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return json
            .decode(response.body)['tooth']
            .cast<Map<String, dynamic>>()
            .map<ToothModel>((map) => ToothModel.fromMap(map))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on SocketException catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> postTooth({required ToothModel data}) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse(url + '/toothes'));

      request.headers
          .addAll({'Authorization': token, 'Content-Type': 'application/json'});
      request.fields['name'] = data.name;
      request.fields['startPrice'] = '${data.startPrice}';

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
    } on SocketException catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> putTooth({required ToothModel data}) async {
    try {
      final request = http.MultipartRequest('PUT', Uri.parse(url + '/toothes'));

      request.headers
          .addAll({'Authorization': token, 'Content-Type': 'application/json'});
      request.fields['toothId'] = '${data.id}';
      request.fields['name'] = data.name;
      request.fields['startPrice'] = '${data.startPrice}';

      if (data.file != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'photo', data.file?.path ?? '',
            contentType: MediaType('image', 'png')));
      }

      final response = await request.send();
      final post = await http.Response.fromStream(response);
      if (post.statusCode == 200) {
        return ResponseModel.fromJson(source: post.body, code: post.statusCode);
      } else {
        throw BadRequestException(error: post.body);
      }
    } on SocketException catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> deteleTooth({required int id}) async {
    try {
      final delete = await http.post(Uri.parse(url + '/toothes/delete/$id'),
          headers: {'Authorization': token});

      if (delete.statusCode == 200) {
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
