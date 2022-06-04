import 'package:clinic/model/reserve_detail_model.dart';
import 'package:clinic/notification/socket/socket_controller.dart';
import 'package:clinic/provider/bloc/notification_bloc.dart';
import 'package:clinic/provider/event/notification_event.dart';
import 'package:clinic/provider/state/notification_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminNotificationPage extends StatefulWidget {
  const AdminNotificationPage({Key? key}) : super(key: key);

  @override
  State<AdminNotificationPage> createState() => _AdminNotificationPageState();
}

class _AdminNotificationPageState extends State<AdminNotificationPage> {
  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context.read<NotificationBloc>().add(FetchAllNotification());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SizedBox(
            width: size.width,
            height: size.height,
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationInitialState) {
                    _onRefresh();
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is NotificationLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is AllNotificationLoadCompleteState) {
                    return ListView.builder(
                        itemCount: state.reserves.length,
                        itemBuilder: (_, index) {
                          ReserveDetailModel? detail;
                          for (var item
                              in state.reserves[index].reserveDetail!) {
                            if (item.isStatus == 'pending') {
                              detail = item;
                              break;
                            }
                          }
                          return Card(
                            child: ListTile(
                              leading: const CircleAvatar(
                                  radius: 20,
                                  child:
                                      Icon(Icons.notifications_active_rounded)),
                              title: const Text('ແຈ້ງເຕືອນການນັດໝາຍລູກຄ້າ'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'ຊື່ລູກຄ້າ: ${state.reserves[index].user!.profile.firstname} ${state.reserves[index].user!.profile.lastname}',
                                      style: text),
                                  Text(
                                      'ເບີໂທ: ${state.reserves[index].user!.phone}'),
                                  Text(
                                      'ວັນທີ: ${fmdate.format(DateTime.parse(detail != null ? detail.date : state.reserves[index].startDate))} ${fmtime.format(DateTime.parse(detail != null ? detail.date : state.reserves[index].startDate))}'),
                                ],
                              ),
                            ),
                          );
                        });
                  }

                  if (state is NotificationErrorState) {
                    return _isStateEmty(message: state.error);
                  } else {
                    return _isStateEmty();
                  }
                },
              ),
            )));
  }

  Widget _isStateEmty({String? message}) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () => _onRefresh(),
            icon:
                const Icon(Icons.sync_rounded, size: 30, color: primaryColor)),
        const SizedBox(
          width: 10,
        ),
        Text(message ?? 'ບໍ່ມີຂໍ້ມູນ'),
      ],
    ));
  }
}
