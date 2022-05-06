import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final fm = NumberFormat("#,###.##", 'en_US');
final fmdate = DateFormat("dd/MM/yyyy", 'en_US');
final sqldate = DateFormat("yyyy-MM-dd", 'en_US');
final fmtime = DateFormat.jms();

const String url = 'http://192.168.43.252:5000/api/v1';
String token =
    'Berer yJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI3YWU4MDVhNy0zZjEwLTRkMzQtODllYi03NjQwYTZjODY1ZjAiLCJwaG9uZSI6Ijk3ODU4ODg4Iiwicm9sZXMiOlsic3VwZXJhZG1pbiJdLCJpYXQiOjE2NTE3NTg3NjcsImV4cCI6MTY1MTg0NTE2N30.SVfzsKhV6MFw-i0eQFSI0pJG4bPleSjwJuVcM3S10uI';

String userFName = '';
String userLName = '';
String userImage = '';

List<String> sections = ['ພາກເໜືອ', 'ພາກກາງ', 'ພາກໃຕ້'];
