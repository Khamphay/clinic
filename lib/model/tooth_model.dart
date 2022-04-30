import 'dart:convert';

class ToothModel {
  final int? id;
  final String name;
  final double startPrice;
  final String image;
  final String? isDelete;
  ToothModel({
    this.id,
    required this.name,
    required this.startPrice,
    required this.image,
     this.isDelete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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

  factory ToothModel.fromJson(String source) => ToothModel.fromMap(json.decode(source));
}
