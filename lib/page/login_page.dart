import 'dart:ui';

import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/page/home_page.dart';
import 'package:clinic/screen/register.dart';
import 'package:clinic/storage/storage.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  String emptyUsername = "";
  String emptyPassword = "";
  bool _showPassword = true;
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
          child: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            // SizedBox(
            //   height: MediaQuery.of(context).size.height,
            //   // child: Image.asset('assets/images/bakg.png'),
            // ),
            Center(
                child: Column(
              children: [
                const SizedBox(height: 40),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    // height: size.height / 3,
                    child: SvgPicture.asset('assets/images/medicine.svg'),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: SizedBox(
                            width: size.width * .9,
                            child: Column(
                              children: [
                                // const Icon(Icons.account_circle, size: 100),
                                Text(
                                  "Sign-in",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                _buildForm()
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      )),
    );
  }

  Widget _buildForm() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Form(
        child: Column(children: [
          CustomContainer(
              title: const Text("ເບີໂທລະສັບ"),
              borderRadius: BorderRadius.circular(radius),
              errorMsg: emptyUsername,
              child: TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                        size: iconSize,
                      )),
                  onChanged: (text) => _userController.text.isNotEmpty
                      ? setState(() => emptyUsername = "")
                      : null)),
          CustomContainer(
              title: const Text("ລະຫັດຜ່ານ"),
              borderRadius: BorderRadius.circular(radius),
              errorMsg: emptyPassword,
              child: TextFormField(
                  controller: _passwordController,
                  obscureText: _showPassword,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon:
                          const Icon(Icons.security_rounded, size: iconSize),
                      suffixIcon: IconButton(
                          icon: _showPassword
                              ? const Icon(Icons.visibility_rounded,
                                  color: Colors.grey)
                              : const Icon(Icons.visibility_off_rounded,
                                  color: primaryColor),
                          onPressed: () {
                            setState(() => _showPassword = !_showPassword);
                          })),
                  onChanged: (text) => _passwordController.text.isNotEmpty
                      ? setState(() => emptyPassword = "")
                      : null)),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Checkbox(
                activeColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                value: isCheck,
                onChanged: (_isCheck) async {
                  if (_isCheck == null || _isCheck == false) {
                    final remeber = RememberMe(
                        username: _userController.text,
                        password: _passwordController.text,
                        remember: false);
                    await remeber.setUser();
                  }

                  setState(() {
                    isCheck = _isCheck ?? false;
                  });
                }),
            const Text("ຈື້ຂ້ອຍໄວ້")
          ]),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  emptyUsername = _userController.text.isEmpty
                      ? "ກະລຸນາປ້ອນຊື່ຜູ້ໃຊ້"
                      : emptyUsername = "";
                  emptyPassword = _passwordController.text.isEmpty
                      ? "ກະລຸນາປ້ອນລະຫັດຜ່ານ"
                      : "";
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                  setState(() {});
                },
                child: const Text('ເຂົ້າສູ່ລະບົບ')),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Divider(height: 2, color: primaryColor),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Center(
                  child: RichText(
                      text: TextSpan(
                          text: 'ລືມລະຫັດຜ່ານ',
                          style: Theme.of(context).textTheme.bodyText1,
                          recognizer: TapGestureRecognizer()..onTap = () {})),
                ),
              ),
              Expanded(
                child: Center(
                  child: RichText(
                      text: TextSpan(
                          text: 'ລົງທະບຽນ',
                          style: Theme.of(context).textTheme.bodyText1,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterPage()));
                            })),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}

// class MyScrollBehavior extends ScrollBehavior {
//   @override
//   Widget buildView(
//       BuildContext context, Widget child, AxisDirection axisDirection) {
//     return child;
//   }
// }
