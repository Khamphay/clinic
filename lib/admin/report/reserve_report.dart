import 'package:clinic/admin/management/reserve_detail.dart';
import 'package:clinic/admin/report/detail.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/provider/bloc/reserve_bloc.dart';
import 'package:clinic/provider/event/reserve_event.dart';
import 'package:clinic/provider/state/reserve_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReserveHistoryPage extends StatefulWidget {
  const ReserveHistoryPage({Key? key}) : super(key: key);

  @override
  State<ReserveHistoryPage> createState() => _ReserveHistoryPageState();
}

class _ReserveHistoryPageState extends State<ReserveHistoryPage> {
  final startController =
      TextEditingController(text: sqldate.format(DateTime.now()));
  final endController =
      TextEditingController(text: sqldate.format(DateTime.now()));

  String start = sqldate.format(DateTime.now()),
      end = sqldate.format(DateTime.now());

  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context
        .read<ReserveBloc>()
        .add(FetchAllReserve(status: 'complete', start: start, end: end));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: const Text("ປະຫວັດການປິ່ນປົວ")),
        body: Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomContainer(
                          width: size.width / 2,
                          title: const Text("ເລີ່ມວັນທີ"),
                          borderRadius: BorderRadius.circular(radius),
                          child: TextFormField(
                              controller: startController,
                              readOnly: true,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.only(left: 10),
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        showDatePicker(
                                                context: context,
                                                initialDate:
                                                    DateTime.parse(start),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 10),
                                                helpText: 'ເລືອກວັນທີ',
                                                cancelText: 'ຍົກເລີກ',
                                                confirmText: 'ຕົກລົງ')
                                            .then((value) {
                                          if (value == null) return;
                                          start = sqldate.format(value);
                                          if (DateTime.parse(end)
                                              .isAfter(value)) {
                                            setState(() {
                                              startController.text =
                                                  fmdate.format(value);
                                            });
                                            _onRefresh();
                                          } else {
                                            mySnackBar(context,
                                                "ວັນທີເລີ່ມຕົ້ນຕ້ອງໜ້ອຍກວ່າວັນທີສິ້ນສຸດ");
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.date_range))))),
                    ),
                    Flexible(
                      child: CustomContainer(
                          width: size.width / 2,
                          title: const Text("ຫາວັນທີ"),
                          borderRadius: BorderRadius.circular(radius),
                          child: TextFormField(
                              controller: endController,
                              readOnly: true,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.only(left: 10),
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        showDatePicker(
                                                context: context,
                                                initialDate:
                                                    DateTime.parse(end),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 10),
                                                helpText: 'ເລືອກວັນທີ',
                                                cancelText: 'ຍົກເລີກ',
                                                confirmText: 'ຕົກລົງ')
                                            .then((value) {
                                          if (value == null) return;
                                          end = sqldate.format(value);
                                          if (DateTime.parse(start)
                                              .isBefore(value)) {
                                            setState(() {
                                              endController.text =
                                                  fmdate.format(value);
                                            });
                                            _onRefresh();
                                          } else {
                                            mySnackBar(context,
                                                "ວັນທີເລີ່ມຕົ້ນຕ້ອງໜ້ອຍກວ່າວັນທີສິ້ນສຸດ");
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.date_range))))),
                    ),
                  ],
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: BlocBuilder<ReserveBloc, ReserveState>(
                      builder: (context, state) {
                        if (state is ReserveInitialState) {
                          _onRefresh();
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (state is ReserveLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                                                builder: (_) =>
                                                    ReportReserveDetailPage(
                                                        data: state
                                                            .reserves[index])));
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
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                    'ເບີໂທ: ${state.reserves[index].user!.phone}'),
                                              ),
                                              const SizedBox(width: 40),
                                              Flexible(
                                                child: Text(
                                                    'ວັນທີ: ${fmdate.format(DateTime.parse(state.reserves[index].startDate))}'),
                                              ),
                                            ],
                                          ),
                                          Text(
                                              'ລາຄາ: ${fm.format(100000)} ກິບ'),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                        color: primaryColor, height: 2)
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
                  ),
                ),
              ],
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
