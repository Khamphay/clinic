import 'package:clinic/page/login_page.dart';
import 'package:clinic/setting/sharesetting.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      title: 'SSP DENTAL CARE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeColor,
        fontFamily: 'NotoSansLao',
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: themeColor,
          titleTextStyle: GoogleFonts.notoSansLao(textStyle: appBarText),
        ),
        primaryIconTheme:
            const IconThemeData(color: primaryColor, size: iconSize),
        iconTheme: const IconThemeData(color: primaryColor, size: iconSize),
        textTheme: TextTheme(
            bodyText1: GoogleFonts.notoSansLao(textStyle: bodyText1),
            bodyText2: GoogleFonts.notoSansLao(textStyle: bodyText2),
            headline1: GoogleFonts.notoSansLao(textStyle: header1Text),
            subtitle1: GoogleFonts.notoSansLao(textStyle: subTitle1)),
        primaryTextTheme: TextTheme(
            bodyText1: GoogleFonts.notoSansLao(textStyle: bodyText1),
            bodyText2: GoogleFonts.notoSansLao(textStyle: bodyText2),
            headline1: GoogleFonts.notoSansLao(textStyle: header1Text),
            subtitle1: GoogleFonts.notoSansLao(textStyle: subTitle1)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryColor,
            textStyle: loginText,
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
