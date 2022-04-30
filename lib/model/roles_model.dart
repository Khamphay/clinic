import 'dart:convert';

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

  factory RolesModel.fromJson(String source) => RolesModel.fromMap(json.decode(source));
}
