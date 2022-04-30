import 'package:clinic/component/drawer.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/screen/appointment.dart';
import 'package:clinic/screen/home.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded), label: 'ໜ້າຫຼັກ'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.menu_open_rounded), label: 'ລາຍການນັດໝາຍ'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.notifications_active_rounded), label: 'ແຈ້ງເຕືອນ'),
  ];
  final widgets = <Widget>[
    const HomeScreen(),
    const PpointmentScreen(),
    const HomeScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          actions: [
            Stack(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_active_rounded,
                        color: iconColor)),
                Positioned(
                    left: 25,
                    top: 5,
                    child: Container(
                        height: 19,
                        width: 19,
                        decoration: BoxDecoration(
                            color: errorColor,
                            borderRadius: BorderRadius.circular(100)),
                        child:
                            const Center(child: Text('4', style: smallText)))),
              ],
            )
          ],
        ),
        drawer: const Drawer(child: DrawerComponet()),
        body: widgets[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: items,
            onTap: (int index) => setState(() {
                  _currentIndex = index;
                })));
  }
}
