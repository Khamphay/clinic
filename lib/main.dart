import 'package:clinic/page/login_page.dart';
import 'package:clinic/setting/sharesetting.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingShareService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinic App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeColor,
        fontFamily: 'NotoSansLao',
        appBarTheme:
            const AppBarTheme(elevation: 0, backgroundColor: themeColor),
        primaryIconTheme:
            const IconThemeData(color: primaryColor, size: iconSize),
        iconTheme: const IconThemeData(color: primaryColor, size: iconSize),
        textTheme: const TextTheme(
            bodyText1: bodyText1,
            bodyText2: bodyText2,
            headline1: header1Text,
            subtitle1: subTitle1),
        primaryTextTheme: const TextTheme(
            bodyText1: bodyText1,
            bodyText2: bodyText2,
            headline1: header1Text,
            subtitle1: subTitle1),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryColor.withOpacity(0.6),
            textStyle: bodyText2Bold,
            fixedSize: const Size(double.maxFinite, 48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
