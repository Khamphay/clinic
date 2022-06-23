import 'package:clinic/alert/progress.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/page/reserve_detail_history.dart';
import 'package:clinic/provider/bloc/reserve_bloc.dart';
import 'package:clinic/provider/event/reserve_event.dart';
import 'package:clinic/provider/state/reserve_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerHistoryReservePage extends StatefulWidget {
  const CustomerHistoryReservePage({Key? key}) : super(key: key);

  @override
  State<CustomerHistoryReservePage> createState() =>
      _CustomerHistoryReserveState();
}

class _CustomerHistoryReserveState extends State<CustomerHistoryReservePage> {
  final startController =
      TextEditingController(text: fmdate.format(DateTime.now()));
  final endController =
      TextEditingController(text: fmdate.format(DateTime.now()));

  String start = sqldate.format(DateTime.now()),
      end = sqldate.format(DateTime.now());

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));

    context
        .read<ReserveBloc>()
        .add(FetchMemberReserve(status: 'complete', start: start, end: end));
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
                                                firstDate: DateTime(
                                                    DateTime.now().year - 10),
                                                lastDate: DateTime.now(),
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
                                                firstDate: DateTime(
                                                    DateTime.now().year - 10),
                                                lastDate: DateTime.now(),
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
                          if (state.reserves.isEmpty) return _isStateEmty();
                          return ListView.builder(
                              itemCount: state.reserves.length,
                              itemBuilder: (_, index) {
                                double total = 0;
                                for (var item
                                    in state.reserves[index].reserveDetail!) {
                                  total += item.price;
                                }
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    CustomerReserveDetailPage(
                                                        data: state
                                                            .reserves[index])));
                                      },
                                      leading: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: primaryColor,
                                          child: Text('${index + 1}')),
                                      title: Text(
                                          state.reserves[index].tooth!.name,
                                          style: title),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'ລາຄາ: ${fm.format(total > 0 ? total : state.reserves[index].tooth!.startPrice)} ກິບ \nວັນທີ: ${fmdate.format(DateTime.parse(state.reserves[index].startDate))}'),
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
