import 'dart:convert';

class UserModel {
  final int? id;
  final String phone;
  final String password;
  final String? isDelete;
  UserModel({
    this.id,
    required this.phone,
    required this.password,
     this.isDelete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'password': password,
      'isDelete': isDelete,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt(),
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      isDelete: map['isDelete'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
