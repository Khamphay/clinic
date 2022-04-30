import 'dart:convert';

class PromotionModel {
  final int? id;
  final String name;
  final String detail;
  final String image;
  final String start;
  final String end;
  final String discount;
  final String? isDelete;
  PromotionModel({
    this.id,
    required this.name,
    required this.detail,
    required this.image,
    required this.start,
    required this.end,
    required this.discount,
     this.isDelete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'detail': detail,
      'image': image,
      'start': start,
      'end': end,
      'discount': discount,
      'isDelete': isDelete,
    };
  }

  factory PromotionModel.fromMap(Map<String, dynamic> map) {
    return PromotionModel(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      detail: map['detail'] ?? '',
      image: map['image'] ?? '',
      start: map['start'] ?? '',
      end: map['end'] ?? '',
      discount: map['discount'] ?? '',
      isDelete: map['isDelete'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionModel.fromJson(String source) => PromotionModel.fromMap(json.decode(source));
}
