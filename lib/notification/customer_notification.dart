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

class CustomerNotification extends StatefulWidget {
  const CustomerNotification({Key? key}) : super(key: key);

  @override
  State<CustomerNotification> createState() => _CustomerNotificationState();
}

class _CustomerNotificationState extends State<CustomerNotification> {
  ReserveDetailModel? detail;

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
                child: Builder(builder: (context) {
                  if (state is NotificationLoadCompleteState) {
                    if (state.reserve.isNotEmpty) {
                      return ListView.builder(
                        itemCount: state.reserve.length,
                        itemBuilder: (BuildContext context, int index) {
                          for (var item
                              in state.reserve[index].reserveDetail!) {
                            detail = item;
                          }
                          return Card(
                            child: ListTile(
                              leading: const CircleAvatar(
                                  radius: 20,
                                  child:
                                      Icon(Icons.notifications_active_rounded)),
                              title: state.reserve[index].isStatus != 'cancel'
                                  ? const Text('ແຈ້ງເຕືອນການນັດໝາຍ')
                                  : const Text('ແຈ້ງເຕືອນການຍົກເລີກ',
                                      style: errorText),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                            'ວັນທີ: ${fmdate.format(DateTime.parse(state.reserve[index].isStatus == 'cancel' ? state.reserve[index].updatedAt! : detail != null ? detail!.date : state.reserve[index].startDate))}'),
                                      ),
                                      const SizedBox(width: 20),
                                      Flexible(
                                        child: Text(
                                            'ເວລາ: ${fmtime.format(DateTime.parse(state.reserve[index].isStatus == 'cancel' ? state.reserve[index].updatedAt! : detail != null ? detail!.date : state.reserve[index].startDate))}'),
                                      )
                                    ],
                                  ),
                                  state.reserve[index].isStatus == 'cancel'
                                      ? RichText(
                                          text: TextSpan(
                                              text: 'ສາເຫດ:',
                                              style: subTitle,
                                              children: [
                                              TextSpan(
                                                  text: state.reserve[index]
                                                      .description,
                                                  style: normalText)
                                            ]))
                                      : const Center()
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return _isStateEmty();
                    }
                  } else {
                    return _isStateEmty();
                  }
                }),
              ));
        },
      ),
    );
  }

  // Future _buildCancel(String description) {
  //   return showDialog(
  //       context: context,
  //       builder: (_) {
  //         return AlertDialog(
  //             title: const Text('ລາຍລະອຽດກ່ຽວການຍົກເລີກ', style: title),
  //             content: SizedBox(height: 200, child: Text('   $description')));
  //       });
  // }

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
