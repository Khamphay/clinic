import 'dart:convert';
import 'package:clinic/source/exception.dart';
import 'package:clinic/source/source.dart';
import 'package:http/http.dart' as http;

class RolesModel {
  final int? id;
  final String name;
  final String displayName;
  RolesModel({
    this.id,
    required this.name,
    required this.displayName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
    };
  }

  factory RolesModel.fromMap(Map<String, dynamic> map) {
    return RolesModel(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      displayName: map['displayName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RolesModel.fromJson(String source) =>
      RolesModel.fromMap(json.decode(source));

  static Future<List<RolesModel>> fetchRoles() async {
    try {
      final response = await http.get(Uri.parse(url + '/admin/users/roles'),
          headers: {'Authorization': token});
      if (response.statusCode == 200) {
        return json
            .decode(response.body)['roles']
            .cast<Map<String, dynamic>>()
            .map<RolesModel>((e) => RolesModel.fromMap(e))
            .toList();
      } else {
        throw FetchDataException(error: response.body);
      }
    } on Exception catch (e) {
      throw FetchDataException(error: e.toString());
    }
  }
}
