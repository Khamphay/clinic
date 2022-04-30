import 'dart:convert';

class DistrictModel {
  final int? id;
  final int provinceId;
  final String name;
  final String? isDelete;
  DistrictModel({
    this.id,
    required this.provinceId,
    required this.name,
     this.isDelete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'provinceId': provinceId,
      'name': name,
      'isDelete': isDelete,
    };
  }

  factory DistrictModel.fromMap(Map<String, dynamic> map) {
    return DistrictModel(
      id: map['id']?.toInt(),
      provinceId: map['provinceId']?.toInt() ?? 0,
      name: map['name'] ?? '',
      isDelete: map['isDelete'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DistrictModel.fromJson(String source) =>
      DistrictModel.fromMap(json.decode(source));
}
