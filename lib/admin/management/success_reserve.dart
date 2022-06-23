import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/model/reserve_detail_model.dart';
import 'package:clinic/model/reserve_model.dart';
import 'package:clinic/provider/bloc/tooth_bloc.dart';
import 'package:clinic/provider/event/tooth_event.dart';
import 'package:clinic/provider/state/tooth_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuccessReservePage extends StatefulWidget {
  const SuccessReservePage({Key? key, required this.data}) : super(key: key);
  final ReserveModel data;

  @override
  State<SuccessReservePage> createState() => _SuccessReservePageState();
}

class _SuccessReservePageState extends State<SuccessReservePage> {
  late ReserveModel data;
  List<ReserveDetailModel> details = [], toothlist = [];
  final priceController = TextEditingController();
  double moneyChange = 0;
  String warning = '';

  @override
  void initState() {
    data = widget.data;
    for (var item in data.reserveDetail!) {
      if (item.isStatus == 'pending') {
        item.amount = 1;
        details.add(item);
        break;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double total = 0;
    for (var i in details) {
      total += i.price;
    }
    return BlocBuilder<ToothBloc, ToothState>(
      builder: (context, state) {
        if (state is ToothInitialState) {
          context.read<ToothBloc>().add(FetchTooth());
        }

        if (state is ToothLoadCompleteState && toothlist.isEmpty) {
          for (var item in state.tooths) {
            toothlist.add(ReserveDetailModel(
                reserveId: data.id ?? 0,
                price: item.startPrice,
                detail: item.name,
                date: sqldate.format(DateTime.now()),
                amount: 1,
                isSelected: false));
          }
        }
        return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(title: const Text('ຊຳລະລາຍການຮັບສາ'), actions: [
              IconButton(
                  onPressed: () {
                    _buildProductList().then((value) {
                      setState(() {});
                    });
                  },
                  icon: const Icon(Icons.add_circle_rounded))
            ]),
            body: Column(
              children: [
                Expanded(
                  child: Component(
                    width: size.width,
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowHeight: 40,
                          columns: menuDetailsColumn(context),
                          rows: List<DataRow>.generate(details.length, (index) {
                            return DataRow(cells: <DataCell>[
                              DataCell(Text('${index + 1}')),
                              DataCell(Text(details[index].detail,
                                  maxLines: 5,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis)),
                              DataCell(Center(
                                child: Text('${details[index].amount}'),
                              )),
                              DataCell(Text(
                                  '${fm.format(details[index].price)} ກິບ')),
                              DataCell(buildEdit(
                                  index: index,
                                  qty: details[index].amount ?? 1)),
                              DataCell(buildRemove(index))
                            ]);
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
                Component(
                    height: 60,
                    width: size.width,
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    child: Center(
                        child: Text('ລວມເງິນທັງໝົດ: ${fm.format(total)} ກິບ',
                            style: title))),
                Component(
                    child: TextField(
                  controller: priceController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      hintText: 'ເງິນທີ່ໄດ້ຮັບ', border: InputBorder.none),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (convertPattenTodouble(priceController.text) > total) {
                        moneyChange =
                            convertPattenTodouble(priceController.text) - total;
                      } else {
                        moneyChange = 0;
                      }
                      setState(() {});
                    }
                  },
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    // height: 40,
                    child: Text(
                        moneyChange < 0
                            ? ''
                            : "ເງິນຖອນ: ${fm.format(moneyChange)} ກິບ",
                        style: title),
                  ),
                ),
                Text(warning.isEmpty ? '' : warning, style: errorText),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (convertPattenTodouble(priceController.text) <
                            total) {
                          setState(() {
                            warning = 'ຈຳນວນເງິນໜ້ອຍກວ່າລາຄາທັງໝົດ';
                          });
                          return;
                        }
                        myProgress(context, null);
                        await ReserveModel.payReserve(
                                reserveId: data.id ?? 0,
                                payPrice: data.price,
                                total: total,
                                details: details)
                            .then((value) {
                          if (value.code == 200) {
                            Navigator.pop(context);
                            showCompletedDialog(
                                    context: context,
                                    title: 'ສຳເລັດການປິ່ນປົວ',
                                    content:
                                        value.message ?? "ການຊຳລະສຳເລັດແລ້ວ")
                                .then(
                                    (value) => {Navigator.pop(context, true)});
                          } else {
                            Navigator.pop(context);
                            showFailDialog(
                                context: context,
                                title: 'ການຊຳລະ',
                                content: "ການຊຳລະບໍ່ສຳເລັດ");
                          }
                        }).onError((error, stackTrace) {
                          Navigator.pop(context);
                          showFailDialog(
                              context: context,
                              title: 'ການຊຳລະ',
                              content: error.toString());
                        });
                      },
                      child: const Text("ຢຶນຢັ້ນການຊຳລະ")),
                )
              ],
            ));
      },
    );
  }

  Widget buildEdit({required int index, required int qty}) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                final qtyCtrl = TextEditingController(text: '$qty');
                return AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("ຈຳນວນ", style: title),
                      Divider(color: primaryColor, height: 2)
                    ],
                  ),
                  content: SizedBox(
                      height: 100,
                      child: TextField(
                          controller: qtyCtrl,
                          textAlign: TextAlign.center,
                          style: title,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          keyboardType: TextInputType.number)),
                  actions: [
                    OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('ຍົກເລີກ')),
                    OutlinedButton(
                        onPressed: () {
                          try {
                            if (qtyCtrl.text.isEmpty || qtyCtrl.text == '0') {
                              qty = 1;
                            } else {
                              qty = int.parse(qtyCtrl.text);
                              if (qty < 1) {
                                qty = 1;
                              }
                            }
                          } on Exception {
                            qty = 1;
                          }
                          details[index].amount = qty;
                          details[index].price = details[index].price * qty;
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: const Text('ຕົກລົງ'))
                  ],
                );
              });
        },
        icon: const Icon(Icons.border_color_rounded, color: primaryColor));
  }

  Widget buildRemove(int index) {
    return IconButton(
        onPressed: () {
          for (int i = 0; i < toothlist.length; i++) {
            if (toothlist[i].detail == details[index].detail) {
              toothlist[i].isSelected = false;
              break;
            }
          }
          details.removeAt(index);
          setState(() {});
        },
        icon: const Icon(Icons.delete_forever, color: Colors.red));
  }

  Future<List<ReserveDetailModel>?> _buildProductList() {
    return showDialog<List<ReserveDetailModel>>(
        context: context,
        builder: (_) => StatefulBuilder(builder: (_context, setMyState) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(10),
                title: const Text('ລາຍການຂໍ້ມູນການຮັບສາ'),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: toothlist.length,
                      itemBuilder: (_context, index) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                activeColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2)),
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    toothlist[index].isSelected = value;
                                    if (value) {
                                      for (var item in details) {
                                        if (item.detail ==
                                            toothlist[index].detail) {
                                          setMyState(() {});
                                          return;
                                        }
                                      }
                                      details.add(ReserveDetailModel(
                                          reserveId: data.id ?? 0,
                                          price: toothlist[index].price,
                                          detail: toothlist[index].detail,
                                          amount: 1,
                                          isStatus: 'complete',
                                          isSelected: false,
                                          date:
                                              sqldate.format(DateTime.now())));
                                    } else {
                                      toothlist[index].isSelected = value;
                                      details.removeWhere((element) =>
                                          element.detail ==
                                          toothlist[index].detail);
                                    }
                                  }

                                  setMyState(() {});
                                },
                                value: toothlist[index].isSelected,
                              ),
                              Text(toothlist[index].detail)
                            ],
                          )),
                ),
                actions: [
                  OutlinedButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: const Text('ຍົກເລີກ')),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("ຢຶນຢັ້ນ")),
                ],
              );
            }));
  }
}

List<DataColumn> menuDetailsColumn(BuildContext context) {
  return <DataColumn>[
    const DataColumn(label: Text('ລ/ດ', style: title)),
    const DataColumn(label: Text('ລາຍການ', style: title)),
    const DataColumn(label: Center(child: Text('ຈ/ນ', style: title))),
    const DataColumn(label: Text('ລາຄາ', style: title)),
    const DataColumn(label: Text('ແກ້ໄຂ', style: title)),
    const DataColumn(label: Text('ລົບ', style: title))
  ];
}
