import 'package:clinic/screen/home.dart';
import 'package:clinic/screen/appointment.dart';
import 'package:clinic/component/drawer.dart';
import 'package:clinic/page/login_page.dart';
import 'package:clinic/screen/notifi.dart';
import 'package:clinic/screen/postlist.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/storage/storage.dart';
import 'package:clinic/style/color.dart';
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
    const AppointmentScreen(),
    const HomeScreen(),
  ];

  final cusmtomerItems = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded), label: 'ໜ້າຫຼັກ'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.menu_open_rounded), label: 'ຂ່າວສານ'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.notifications_active_rounded), label: 'ແຈ້ງເຕືອນ'),
  ];
  final cusmtomerWidgets = <Widget>[
    const HomeScreen(),
    const PostScreen(),
    const NotificationScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  final remeber =
                      RememberMe(username: '', password: '', remember: false);
                  await remeber.setUser();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                tooltip: 'ອອກຈາກລະບົບ',
                icon:
                    const Icon(Icons.settings_power_outlined, color: iconColor))
          ],
        ),
        drawer: const Drawer(child: DrawerComponet()),
        body:
            isAdmin ? widgets[_currentIndex] : cusmtomerWidgets[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: isAdmin ? items : cusmtomerItems,
            onTap: (int index) => setState(() {
                  _currentIndex = index;
                })));
  }
}
