import 'package:clinic/page/login_page.dart';
import 'package:clinic/provider/bloc/district_bloc.dart';
import 'package:clinic/provider/bloc/post_bloc.dart';
import 'package:clinic/provider/bloc/profile_bloc.dart';
import 'package:clinic/provider/bloc/province_bloc.dart';
import 'package:clinic/provider/repository/district_repository.dart';
import 'package:clinic/provider/repository/post_repository.dart';
import 'package:clinic/provider/repository/profile_repository.dart';
import 'package:clinic/provider/repository/province_repository.dart';
import 'package:clinic/setting/sharesetting.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProvinceBloc>(
            create: (_context) =>
                ProvinceBloc(provinceRepo: ProvinceRepository())),
        BlocProvider<DistrictBloc>(
            create: (_context) =>
                DistrictBloc(districtRepo: DistrictRepository())),
        BlocProvider<PostBloc>(
            create: (_context) => PostBloc(postRepo: PostRepository())),
        BlocProvider<ProfileBloc>(
            create: (_context) => ProfileBloc(profileRepo: ProfileRepository()))
      ],
      child: MaterialApp(
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
