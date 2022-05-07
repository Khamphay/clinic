import 'package:clinic/component/component.dart';
import 'package:clinic/management/post.dart';
import 'package:clinic/management/promotion.dart';
import 'package:clinic/management/province.dart';
import 'package:clinic/management/customer.dart';
import 'package:clinic/management/employee.dart';
import 'package:clinic/management/tooth.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(children: [
          Expanded(
              child: Component(
                  // width: size.width,
                  // color: primaryColor.withOpacity(0.4),
                  child: Center(
                      child: Text('ໂປຣໂມຊັນ',
                          style: Theme.of(context).textTheme.headline1)))),
          const SizedBox(height: 10),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    children: [
                      Component(
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ProvincePage())),
                              focusColor: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.edit_note_rounded, size: 40),
                                    Center(
                                        child: Text("ຂໍ້ມູນແຂວງ",
                                            style: bodyText2Bold))
                                  ]))),
                      Component(
                          child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const EmployeePage())),
                              focusColor: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.person, size: 40),
                                    Center(
                                        child: Text("ຂໍ້ມູນພະນັກງານ",
                                            style: bodyText2Bold))
                                  ]))),
                      Component(
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ToothPage())),
                              focusColor: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.add_reaction_outlined, size: 40),
                                    Center(
                                        child: Text("ຂໍ້ມູນແຂ້ວ",
                                            style: bodyText2Bold))
                                  ]))),
                      Component(
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const PromotionPage())),
                              focusColor: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.card_giftcard_rounded, size: 40),
                                    Center(
                                        child: Text("ໂປຣໂມຊັນ",
                                            style: bodyText2Bold))
                                  ]))),
                      Component(
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const PostPage())),
                              focusColor: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.newspaper_rounded, size: 40),
                                    Center(
                                        child: Text("ຂ່າວສານ",
                                            style: bodyText2Bold))
                                  ]))),
                      Component(
                        child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CustomerPage())),
                            focusColor: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.account_circle_outlined, size: 40),
                                  Center(
                                      child:
                                          Text("ລູກຄ້າ", style: bodyText2Bold))
                                ])),
                      ),
                      Component(
                          child: InkWell(
                              onTap: () {},
                              focusColor: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.calendar_month_rounded,
                                        size: 40),
                                    Center(
                                        child: Text("ນັດໝາຍລູກຄ້າ",
                                            style: bodyText2Bold))
                                  ]))),
                      Component(
                          child: InkWell(
                              onTap: () {},
                              focusColor: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.list_alt_rounded, size: 40),
                                    Text("ປະຫວັດການປິ່ນປົວ",
                                        textAlign: TextAlign.center,
                                        style: bodyText2Bold)
                                  ]))),
                    ]),
              ))
        ]),
      ),
    );
  }
}
