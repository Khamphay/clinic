import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final fm = NumberFormat("#,###.##", 'en_US');
final fmdate = DateFormat("dd/MM/yyyy", 'en_US');
final sqldate = DateFormat("yyyy-MM-dd", 'en_US');
final fmtime = DateFormat.jms();

const String url = 'http://192.168.43.252:5000/api/v1';
String token = '';

String userFName = '';
String userLName = '';
String userImage = '';

List<String> sections = ['ພາກເໜືອ', 'ພາກກາງ', 'ພາກໃຕ້'];
