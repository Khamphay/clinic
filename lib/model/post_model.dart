import 'dart:convert';
import 'dart:io';
import 'package:clinic/model/respone_model.dart';
import 'package:clinic/source/exception.dart';
import 'package:clinic/source/source.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PostModel {
  final int? id;
  final String name;
  final String detail;
  final String? image;
  final String? isDelete;
  final File? file;
  PostModel({
    this.id,
    required this.name,
    required this.detail,
    this.image,
    this.file,
    this.isDelete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'detail': detail,
      'image': image,
      'isDelete': isDelete,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      detail: map['detail'] ?? '',
      image: map['image'] ?? '',
      isDelete: map['isDelete'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));

  static Future<List<PostModel>> fetchPost() async {
    try {
      final response = await http
          .get(Uri.parse(url + '/posts'), headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['post']
            .cast<Map<String, dynamic>>()
            .map<PostModel>((data) => PostModel.fromMap(data))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  static Future<ResponseModel> postPost({required PostModel data}) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url + '/posts'));

      request.headers
          .addAll({'Authorization': token, 'Content-Type': 'application/json'});
      request.fields['name'] = data.name;
      request.fields['detail'] = data.detail;

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

  static Future<ResponseModel> putPost({required PostModel data}) async {
    try {
      final request = http.MultipartRequest('PUT', Uri.parse(url + '/posts'));

      request.headers
          .addAll({'Authorization': token, 'Content-Type': 'application/json'});
      request.fields['postId'] = '${data.id}';
      request.fields['name'] = data.name;
      request.fields['detail'] = data.detail;

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

  static Future<ResponseModel> detelePost({required int id}) async {
    try {
      final delete = await http.post(Uri.parse(url + '/posts/delete/$id'),
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
