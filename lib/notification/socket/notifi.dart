import 'dart:convert';

class Notifica {
  String id;
  String message;
  Notifica({
    required this.id,
    required this.message,
  });

  factory Notifica.fromMap(Map<String, dynamic> map) {
    return Notifica(
      id: map['id'] ?? '',
      message: map['message'] ?? '',
    );
  }

  factory Notifica.fromJson(String source) =>
      Notifica.fromMap(json.decode(source)['data']);
}
