import 'package:clinic/model/login_model.dart';
import 'package:clinic/page/home_page.dart';
import 'package:clinic/page/login_page.dart';
import 'package:clinic/setting/sharesetting.dart';
import 'package:clinic/storage/storage.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SlapScreen extends StatefulWidget {
  const SlapScreen({Key? key}) : super(key: key);

  @override
  State<SlapScreen> createState() => _SlapScreenState();
}

class _SlapScreenState extends State<SlapScreen> {
  @override
  void initState() {
    super.initState();
    _loginAuto();
  }

  Future _loginAuto() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = RememberMe.getUser();
    if (user.remember) {
      await LoginModel.login(
              data: LoginModel(phone: user.username, password: user.password))
          .then((login) async {
        if (login.roles != null &&
            login.roles!.isNotEmpty &&
            login.accessToken != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomePage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const LoginPage()));
        }
      }).catchError((onError) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginPage()));
      });
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: [
          Positioned(
            top: size.height / 3,
            left: size.width / 3,
            child: SvgPicture.asset(
              'assets/images/loading.svg',
              height: 150,
              width: 150,
            ),
          ),
          Positioned(
              top: size.height / 2.835,
              left: size.width / 2.64,
              child: const SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(strokeWidth: 5))),
        ],
      ),
    );
  }
}
