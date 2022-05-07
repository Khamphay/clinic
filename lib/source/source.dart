import 'package:intl/intl.dart';

final fm = NumberFormat("#,###.##", 'en_US');
final fmdate = DateFormat("dd/MM/yyyy", 'en_US');
final sqldate = DateFormat("yyyy-MM-dd", 'en_US');
final fmtime = DateFormat.jms();

const String url = 'http://192.168.43.252:5000/api/v1';
const String urlImg = 'http://192.168.43.252:5000/images';
String token = '';

String userFName = '';
String userLName = '';
String userImage = '';

List<String> sections = ['ພາກເໜືອ', 'ພາກກາງ', 'ພາກໃຕ້'];

bool isNumeric(String str) {
  try {
    if (str.isEmpty) {
      return false;
    }
    return double.tryParse(str) != null;
  } on Exception {
    return false;
  }
}

double convertPattenTodouble(String value) {
  String str = '0';
  for (int i = 0; i < value.length; i++) {
    if (value[i].isNotEmpty && value[i] != ',' && isNumeric(value[i]) ||
        value[i] == '.') {
      str += value[i];
    }
  }
  return double.parse(str);
}
