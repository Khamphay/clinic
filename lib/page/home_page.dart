import 'package:badges/badges.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/notification/admin_notification.dart';
import 'package:clinic/notification/customer_notification.dart';
import 'package:clinic/notification/socket/notifi.dart';
import 'package:clinic/notification/socket/socket_controller.dart';
import 'package:clinic/page/promotionlist_page.dart';
import 'package:clinic/provider/bloc/notification_bloc.dart';
import 'package:clinic/provider/bloc/promotion_bloc.dart';
import 'package:clinic/provider/event/notification_event.dart';
import 'package:clinic/provider/event/promotion_event.dart';
import 'package:clinic/provider/notification_provider.dart';
import 'package:clinic/provider/state/notification_state.dart';
import 'package:clinic/provider/state/promotion_state.dart';
import 'package:clinic/screen/home.dart';
import 'package:clinic/screen/appointment.dart';
import 'package:clinic/component/drawer.dart';
import 'package:clinic/page/login_page.dart';
import 'package:clinic/page/postlist.dart';
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
    const AdminNotificationPage(),
  ];

  final cusmtomerWidgets = <Widget>[
    const HomeScreen(),
    const PostScreen(),
    const PromotionListPage(),
    const CustomerNotification(),
  ];
  int _currentIndex = 0;

  // StreamSocket stream = StreamSocket();
  @override
  void initState() {
    SocketController.initialSocket();

    // SocketController.socket
    //     .on("message", (data) => stream.socketRespone.sink.add(data));

    SocketController.socket.on('prm_msg', (data) {
      if (isCustomer) {
        context.read<PromotionBloc>().add(FetchCustomerPromotion());
      }
    });

    SocketController.socket.on("notifi_msg", (data) {
      if (isAdmin || isEmployee) {
        _onRefreshAllNotifications();
      } else {
        _onRefreshMemberNotifications();
      }
    });

    if (isAdmin || isEmployee) {
      _onRefreshAllNotifications();
    } else {
      _onRefreshMemberNotifications();
    }
    super.initState();
  }

  @override
  dispose() {
    // stream.dispose();
    SocketController.disconnect();
    super.dispose();
  }

  Future<void> _onRefreshMemberNotifications() async {
    await Future.delayed(const Duration(seconds: 0));
    context.read<NotificationBloc>().add(FetchMemberNotification());
  }

  Future<void> _onRefreshAllNotifications() async {
    await Future.delayed(const Duration(seconds: 0));
    context.read<NotificationBloc>().add(FetchAllNotification());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationManager>(builder: (context, values, child) {
      final items = <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: 'ໜ້າຫຼັກ'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.menu_open_rounded), label: 'ລາຍການນັດໝາຍວັນນີ້'),
        BottomNavigationBarItem(
            icon: values.adminNotifi == ''
                ? const Icon(Icons.notifications_active_rounded)
                : Badge(
                    child: const Icon(Icons.notifications_active_rounded),
                    badgeColor: Colors.red,
                    badgeContent: Text(
                      values.adminNotifi,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    )),
            label: 'ແຈ້ງເຕືອນ'),
      ];

      final cusmtomerItems = <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: 'ໜ້າຫຼັກ'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_rounded), label: 'ຂ່າວສານ'),
        BottomNavigationBarItem(
            icon: values.promotionNotifi == ''
                ? const Icon(Icons.card_giftcard_rounded)
                : Badge(
                    child: const Icon(Icons.card_giftcard_rounded),
                    badgeColor: Colors.red,
                    badgeContent: Text(
                      values.promotionNotifi,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    )),
            label: 'ໂປຣໂມຊັນ'),
        BottomNavigationBarItem(
            icon: values.customNotifi == ''
                ? const Icon(Icons.notifications_active_rounded)
                : Badge(
                    child: const Icon(Icons.notifications_active_rounded),
                    badgeColor: Colors.red,
                    badgeContent: Text(
                      values.customNotifi,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    )),
            label: 'ແຈ້ງເຕືອນ'),
      ];

      return BlocBuilder<NotificationBloc, NotificationState>(
        builder: (_, state) {
          if (state is NotificationLoadCompleteState) {
            if (state.reserve != null) {
              Future.delayed(const Duration(seconds: 0)).then((value) => context
                  .read<NotificationManager>()
                  .setCustomNotifi(notifi: '1'));
            } else {
              Future.delayed(const Duration(seconds: 0)).then((value) => context
                  .read<NotificationManager>()
                  .setCustomNotifi(notifi: ''));
            }
          }

          if (state is AllNotificationLoadCompleteState) {
            if (state.reserves.isNotEmpty) {
              Future.delayed(const Duration(seconds: 0)).then((value) => context
                  .read<NotificationManager>()
                  .setAdminNotifi(notifi: '${state.reserves.length}'));
            } else {
              Future.delayed(const Duration(seconds: 0)).then((value) => context
                  .read<NotificationManager>()
                  .setAdminNotifi(notifi: ''));
            }
          }

          if (state is NotificationErrorState) {
            Future.delayed(const Duration(seconds: 0)).then((value) => context
                .read<NotificationManager>()
                .setCustomNotifi(notifi: ''));

            Future.delayed(const Duration(seconds: 0)).then((value) =>
                context.read<NotificationManager>().setAdminNotifi(notifi: ''));
          }

          return BlocBuilder<PromotionBloc, PromotionState>(
            builder: (_, state) {
              if (state is PromotionInitialState) {
                if (isAdmin || isEmployee) {
                  context.read<PromotionBloc>().add(FetchPromotion());
                } else {
                  context.read<PromotionBloc>().add(FetchCustomerPromotion());
                }
              }

              if (state is CustomerPromotionLoadCompleteState) {
                if (state.promotions.isNotEmpty) {
                  Future.delayed(const Duration(seconds: 0)).then((value) =>
                      context.read<NotificationManager>().setPromotionNotifi(
                          notifi: '${state.promotions.length}'));
                } else {
                  Future.delayed(const Duration(seconds: 0)).then((value) =>
                      context
                          .read<NotificationManager>()
                          .setPromotionNotifi(notifi: ''));
                }
              }

              if (state is PromotionErrorState) {
                Future.delayed(const Duration(seconds: 0)).then((value) =>
                    context
                        .read<NotificationManager>()
                        .setPromotionNotifi(notifi: ''));
              }
              return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    title: const Text('SSP DENTAL CARE'),
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
                              color: iconColor)),
                    ],
                  ),
                  drawer: const Drawer(child: DrawerComponet()),
                  body: isAdmin || isEmployee
                      ? widgets[_currentIndex]
                      : cusmtomerWidgets[_currentIndex],
                  bottomNavigationBar: BottomNavigationBar(
                      unselectedItemColor: Colors.black87,
                      selectedItemColor: primaryColor,
                      currentIndex: _currentIndex,
                      items: isAdmin || isEmployee ? items : cusmtomerItems,
                      onTap: (int index) => setState(() {
                            _currentIndex = index;
                          })));
            },
          );
        },
      );
    });
  }
}
