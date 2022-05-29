import 'package:badges/badges.dart';
import 'package:clinic/notification/customer_notification.dart';
import 'package:clinic/provider/bloc/notification_bloc.dart';
import 'package:clinic/provider/bloc/reserve_bloc.dart';
import 'package:clinic/provider/event/notification_event.dart';
import 'package:clinic/provider/event/reserve_event.dart';
import 'package:clinic/provider/notification_provider.dart';
import 'package:clinic/provider/state/notification_state.dart';
import 'package:clinic/provider/state/reserve_state.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final widgets = <Widget>[
    const HomeScreen(),
    const AppointmentScreen(),
    const HomeScreen(),
  ];

  final cusmtomerWidgets = <Widget>[
    const HomeScreen(),
    const PostScreen(),
    const CustomerNotification(),
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 0));
    context.read<NotificationBloc>().add(FetchMemberNotification());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationManager>(builder: (context, values, child) {
      final items = <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: 'ໜ້າຫຼັກ'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.menu_open_rounded), label: 'ລາຍການນັດໝາຍ'),
        BottomNavigationBarItem(
            icon: values.adminNotifi == ''
                ? const Icon(Icons.notifications_active_rounded)
                : Badge(
                    child: const Icon(Icons.notifications_active_rounded),
                    badgeColor: Colors.red,
                    badgeContent: Text(
                      values.adminNotifi,
                      style: const TextStyle(color: Colors.white),
                    )),
            label: 'ແຈ້ງເຕືອນ'),
      ];

      final cusmtomerItems = <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: 'ໜ້າຫຼັກ'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.menu_open_rounded), label: 'ຂ່າວສານ'),
        BottomNavigationBarItem(
            icon: values.customNotifi == ''
                ? const Icon(Icons.notifications_active_rounded)
                : Badge(
                    child: const Icon(Icons.notifications_active_rounded),
                    badgeColor: Colors.red,
                    badgeContent: Text(
                      values.customNotifi,
                      style: const TextStyle(color: Colors.white),
                    )),
            label: 'ແຈ້ງເຕືອນ'),
      ];

      return BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoadCompleteState) {
            if (state.reserve != null) {
              context.read<NotificationManager>().setCustomNotifi(notifi: '1');
            } else {
              context.read<NotificationManager>().setCustomNotifi(notifi: '0');
            }
          }

          return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: () async {
                        final remeber = RememberMe(
                            username: '', password: '', remember: false);
                        await remeber.setUser();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()));
                      },
                      tooltip: 'ອອກຈາກລະບົບ',
                      icon: const Icon(Icons.settings_power_outlined,
                          color: iconColor))
                ],
              ),
              drawer: const Drawer(child: DrawerComponet()),
              body: isAdmin
                  ? widgets[_currentIndex]
                  : cusmtomerWidgets[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  items: isAdmin ? items : cusmtomerItems,
                  onTap: (int index) => setState(() {
                        _currentIndex = index;
                      })));
        },
      );
    });
  }
}
