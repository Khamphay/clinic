import 'dart:convert';

class ProvinceModel {
  final int? id;
  final String name;
  final String section;
  final String? isDelete;
  ProvinceModel({
    this.id,
    required this.name,
    required this.section,
     this.isDelete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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

  factory ProvinceModel.fromJson(String source) => ProvinceModel.fromMap(json.decode(source));
}
