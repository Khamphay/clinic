import 'dart:convert';

class CustomerModel {
  final int? id;
  final String userId;
  final String firstname;
  final String lastname;
  final String gender;
  final String birthDate;
  final String phone;
  final String? isDelete;
  CustomerModel({
    this.id,
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.gender,
    required this.birthDate,
    required this.phone,
    this.isDelete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'firstname': firstname,
      'lastname': lastname,
      'gender': gender,
      'birthDate': birthDate,
      'isDelete': isDelete,
      'phone': phone,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id']?.toInt(),
      userId: map['userId'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: map['birthDate'] ?? '',
      isDelete: map['isDelete'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source));
}

class ReserveDetails {
  final int? id;
  final int reserveId;
  final String date;
  final String detail;
  final String isStatus;
  ReserveDetails({
    this.id,
    required this.reserveId,
    required this.date,
    required this.detail,
    required this.isStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reserveId': reserveId,
      'date': date,
      'detail': detail,
      'isStatus': isStatus,
    };
  }

  factory ReserveDetails.fromMap(Map<String, dynamic> map) {
    return ReserveDetails(
      id: map['id']?.toInt(),
      reserveId: map['reserveId']?.toInt() ?? 0,
      date: map['date'] ?? '',
      detail: map['detail'] ?? '',
      isStatus: map['isStatus'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReserveDetails.fromJson(String source) =>
      ReserveDetails.fromMap(json.decode(source));
}
