import 'package:clinic/admin/management/reserve_detail.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/model/reserve_detail_model.dart';
import 'package:clinic/model/reserve_model.dart';
import 'package:clinic/notification/socket/socket_controller.dart';
import 'package:clinic/provider/bloc/reserve_bloc.dart';
import 'package:clinic/provider/event/reserve_event.dart';
import 'package:clinic/provider/state/reserve_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservePage extends StatefulWidget {
  const ReservePage({Key? key}) : super(key: key);

  @override
  State<ReservePage> createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  ReserveDetailModel? detail;

  Future<void> _onRefresh() async {
    if (mounted) {
      Future.delayed(const Duration(seconds: 0));
      context.read<ReserveBloc>().add(FetchAllReserve(status: 'pending'));
    }
  }

  @override
  void initState() {
    SocketController.socket.on('notifi_msg', (data) {
      if (isAdmin || isEmployee) {
        _onRefresh();
      }
    });

    _onRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: const Text("ການນັດໝາຍ")),
        body: SizedBox(
            width: size.width,
            height: size.height,
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: BlocBuilder<ReserveBloc, ReserveState>(
                builder: (context, state) {
                  if (state is ReserveInitialState) {
                    _onRefresh();
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ReserveLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ReserveLoadCompleteState) {
                    if (state.reserves.isEmpty) return _isStateEmty();
                    return ListView.builder(
                        itemCount: state.reserves.length,
                        itemBuilder: (_, index) {
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
                                      radius: 20,
                                      backgroundColor: primaryColor,
                                      child: Text('${index + 1}')),
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
                                          'ວັນທີນັດໝາຍ: ${fmdate.format(DateTime.parse(detail != null ? detail!.date : state.reserves[index].startDate))} ${fmtime.format(DateTime.parse(detail != null ? detail!.date : state.reserves[index].startDate))}'),
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

                  if (state is ReserveErrorState) {
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
