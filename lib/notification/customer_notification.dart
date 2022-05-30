import 'package:clinic/provider/bloc/notification_bloc.dart';
import 'package:clinic/provider/event/notification_event.dart';
import 'package:clinic/provider/state/notification_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerNotification extends StatefulWidget {
  const CustomerNotification({Key? key}) : super(key: key);

  @override
  State<CustomerNotification> createState() => _CustomerNotificationState();
}

class _CustomerNotificationState extends State<CustomerNotification> {
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 0));
    context.read<NotificationBloc>().add(FetchMemberNotification());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return SizedBox(
              height: size.height,
              width: size.width,
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: Column(
                  children: [
                    Builder(builder: (context) {
                      if (state is NotificationLoadCompleteState) {
                        if (state.reserve != null) {
                          return Card(
                            child: ListTile(
                              leading: const CircleAvatar(
                                  radius: 20,
                                  child:
                                      Icon(Icons.notifications_active_rounded)),
                              title: const Text('ແຈ້ງເຕືອນການນັດໝາຍ'),
                              subtitle: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                        'ວັນທີ: ${fmdate.format(DateTime.parse(state.reserve!.startDate))}'),
                                  ),
                                  const SizedBox(width: 40),
                                  Flexible(
                                    child: Text(
                                        'ເວລາ: ${fmtime.format(DateTime.parse(state.reserve!.startDate))}'),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return _isStateEmty();
                        }
                      } else {
                        return _isStateEmty();
                      }
                    })
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget _isStateEmty({String? message}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () => _onRefresh(),
              icon: const Icon(Icons.sync_rounded,
                  size: 30, color: primaryColor)),
          const SizedBox(
            width: 10,
          ),
          Text(message ?? 'ບໍ່ມີຂໍ້ມູນ'),
        ],
      )),
    );
  }
}
