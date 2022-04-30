import 'dart:convert';

class PostModel {
  final int? id;
  final String name;
  final String detail;
  final String image;
  final String? isDelete;
  PostModel({
    this.id,
    required this.name,
    required this.detail,
    required this.image,
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

  factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source));
}
