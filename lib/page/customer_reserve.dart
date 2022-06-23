import 'package:clinic/admin/management/form/reserve_form.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/model/reserve_detail_model.dart';
import 'package:clinic/model/reserve_model.dart';
import 'package:clinic/provider/bloc/reserve_bloc.dart';
import 'package:clinic/provider/event/reserve_event.dart';
import 'package:clinic/provider/state/reserve_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerReservePage extends StatefulWidget {
  const CustomerReservePage({Key? key}) : super(key: key);

  @override
  State<CustomerReservePage> createState() => _CustomerReserveState();
}

class _CustomerReserveState extends State<CustomerReservePage> {
  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));

    context.read<ReserveBloc>().add(FetchMemberReserve(status: 'pending'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: const Text("ການນັດໝາຍ"), actions: [
          IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ReserveFormPage(edit: false)));
              })
        ]),
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
                                            builder: (_) => ReserveFormPage(
                                                edit: true,
                                                tooth:
                                                    state.reserves[index].tooth,
                                                reserve:
                                                    state.reserves[index])));
                                  },
                                  // leading: CircleAvatar(
                                  //     radius: 20, child: Text('${index + 1}')),
                                  title: Text(state.reserves[index].tooth!.name,
                                      style: title),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'ລາຄາ: ${fm.format(state.reserves[index].price)} ກິບ'),
                                      Text(
                                          'ວັນທີ: ${fmdate.format(DateTime.parse(detail != null ? detail.date : state.reserves[index].startDate))} ${fmtime.format(DateTime.parse(detail != null ? detail.date : state.reserves[index].startDate))}'),
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
    await ReserveModel.cancelReserve(reserveId: data.id ?? 0, description: '')
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
