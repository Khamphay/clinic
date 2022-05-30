import 'package:clinic/admin/management/reserve_detail.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/model/reserve_model.dart';
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
  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context.read<ReserveBloc>().add(FetchAllReserve(status: 'pending'));
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
                    return ListView.builder(
                        itemCount: state.reserves.length,
                        itemBuilder: (_, index) {
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
                                          'ເບີໂທ: ${state.reserves[index].user!.phone} \nວັນທີ: ${fmdate.format(DateTime.parse(state.reserves[index].startDate))}'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        showQuestionDialog(
                                                context: context,
                                                title: 'ຍົກເລີກ',
                                                content:
                                                    "ຕ້ອງການຍົກເລີກຂໍ້ມູນແມ່ນບໍ?")
                                            .then((value) {
                                          if (value != null && value) {
                                            _cancelReserve(
                                                state.reserves[index]);
                                          }
                                        });
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

  void _cancelReserve(ReserveModel data) async {
    myProgress(context, null);
    await ReserveModel.cancelReserve(reserveId: data.id ?? 0).then((value) {
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
