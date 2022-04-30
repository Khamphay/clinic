import 'dart:convert';

class ReserveModel {
  final int? id;
  final int toothId;
  final String startDate;
  final String endDate;
  final String promotionId;
  final double price;
  final String isStatus;
  final String firstName;
  final String lastName;
  final String? isDelete;
  ReserveModel({
    this.id,
    required this.toothId,
    required this.startDate,
    required this.endDate,
    required this.promotionId,
    required this.price,
    required this.isStatus,
    required this.firstName,
    required this.lastName,
    this.isDelete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'toothId': toothId,
      'startDate': startDate,
      'endDate': endDate,
      'promotionId': promotionId,
      'price': price,
      'isStatus': isStatus,
      'firstName': firstName,
      'lastName': lastName,
      'isDelete': isDelete,
    };
  }

  factory ReserveModel.fromMap(Map<String, dynamic> map) {
    return ReserveModel(
      id: map['id']?.toInt(),
      toothId: map['toothId']?.toInt() ?? 0,
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      promotionId: map['promotionId'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      isStatus: map['isStatus'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      isDelete: map['isDelete'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReserveModel.fromJson(String source) => ReserveModel.fromMap(json.decode(source));
}
