import 'package:clinic/admin/management/reserve_detail.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/model/reserve_detail_model.dart';
import 'package:clinic/model/reserve_model.dart';
import 'package:clinic/notification/socket/socket_controller.dart';
import 'package:clinic/provider/bloc/notification_bloc.dart';
import 'package:clinic/provider/event/notification_event.dart';
import 'package:clinic/provider/state/notification_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
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
                builder: (_, state) {
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
                          return Column(
                            children: [
                              ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ReserveDetailPage(
                                                data: state.reserves[index])));
                                  },
                                  leading: CircleAvatar(
                                      radius: 20, child: Text('${index + 1}')),
                                  title: Text(
                                      '${state.reserves[index].user!.profile.firstname} ${state.reserves[index].user!.profile.lastname}',
                                      style: title),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'ເບີໂທ: ${state.reserves[index].user!.phone}'),
                                      Text(
                                          'ວັນທີ: ${fmdate.format(DateTime.parse(detail != null ? detail.date : state.reserves[index].startDate))} ${fmtime.format(DateTime.parse(detail != null ? detail.date : state.reserves[index].startDate))}'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      onPressed: () async {
                                        // showQuestionDialog(
                                        //         context: context,
                                        //         title: 'ຍົກເລີກ',
                                        //         content:
                                        //             "ຕ້ອງການຍົກເລີກຂໍ້ມູນແມ່ນບໍ?")
                                        //     .then((value) async {
                                        //   if (value != null && value) {
                                        await showCancel(state.reserves[index]);
                                        //   }
                                        // });
                                      },
                                      icon: const Icon(Icons.cancel_outlined,
                                          color: Colors.red))),
                              const Divider(color: primaryColor, height: 2)
                            ],
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

  Future showCancel(ReserveModel data) {
    final cancelCtrl = TextEditingController();
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(10),
            title: const Text('ຍົກເລີກການນັດໝາຍ'),
            content: SizedBox(
                width: double.minPositive,
                height: 120,
                child: Component(
                    padding: const EdgeInsets.all(4),
                    child: TextField(
                        controller: cancelCtrl,
                        maxLines: 4,
                        decoration: const InputDecoration(
                            hintText: 'ສາເຫດໃນການຍົກເລີກ',
                            border: InputBorder.none)))),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ຍົກເລີກ')),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _cancelReserve(data, cancelCtrl.text);
                  },
                  child: const Text('ຢືນຢັ້ນ'))
            ],
          );
        });
  }

  void _cancelReserve(ReserveModel data, String description) async {
    myProgress(context, null);
    await ReserveModel.cancelReserve(
            reserveId: data.id ?? 0, description: description)
        .then((value) {
      if (value.code == 200) {
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ຍົກເລີກ',
                content: "ຍົກເລີກຂໍ້ມູນສຳເລັດແລ້ວ")
            .then((value) => _onRefresh());
      } else {
        Navigator.pop(context);
        showFailDialog(
            context: context,
            title: 'ຍົກເລີກ',
            content: "ຍົກເລີກຂໍ້ມູນບໍ່ສຳເລັດ");
      }
    }).catchError((e) {
      Navigator.pop(context);
      showFailDialog(context: context, title: 'ຍົກເລີກ', content: e.toString());
    });
  }
}
