import 'package:clinic/admin/management/form/next_reserve_form.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/model/reserve_detail_model.dart';
import 'package:clinic/model/reserve_model.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';

class ReserveDetailPage extends StatefulWidget {
  const ReserveDetailPage({Key? key, required this.data}) : super(key: key);
  final ReserveModel data;

  @override
  State<ReserveDetailPage> createState() => _ReserveDetailPageState();
}

class _ReserveDetailPageState extends State<ReserveDetailPage> {
  late ReserveModel data;
  ReserveDetailModel? detail;
  @override
  void initState() {
    data = widget.data;

    for (var item in data.reserveDetail!) {
      if (item.isStatus == 'pending') {
        detail = item;
        break;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('ລາຍລະອຽດການນັດໝາຍ')),
      body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Flexible(
                      child: ElevatedButton(
                          onPressed: detail == null
                              ? null
                              : () async {
                                  await showPaid(detail!.price);
                                },
                          child: const Text('ຊຳລະ'))),
                  const SizedBox(width: 10),
                  Flexible(
                    child: ElevatedButton(
                        onPressed: detail == null
                            ? null
                            : () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NextReservePage(
                                            reserveId: data.id ?? 0,
                                            data: detail))).then((value) {
                                  if (value != null && value) {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                        child: const Text('ນັດໝາຍຄັ້ງຕໍ່ໄປ')),
                  )
                ]),
              ),
              Expanded(
                child: Component(
                  width: size.width,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("ຂໍ້ມູນລູກຄ້າ", style: title),
                      const Divider(color: primaryColor, height: 2),
                      Text(
                          'ຊື່ ແລະ ນາມສະກຸນ: ${data.user!.profile.firstname} ${data.user!.profile.lastname}'),
                      Row(
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ເບິໂທ: ${data.user!.phone}'),
                                Text('ບ້ານ: ${data.user!.profile.village}'),
                                Text(
                                    'ເມືອງ: ${data.user!.profile.district!.name}'),
                                Text(
                                    'ແຂວງ: ${data.user!.profile.province!.name}'),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Center(
                              child: data.user!.profile.image!.isNotEmpty
                                  ? CircleAvatar(
                                      maxRadius: 50,
                                      backgroundImage: NetworkImage(
                                          "$urlImg/${data.user!.profile.image!}"))
                                  : const Icon(Icons.account_circle_outlined,
                                      size: 80, color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text("ຂໍ້ມູນການຈອງ", style: title),
                      const Divider(color: primaryColor, height: 2),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ລາຍການ: ${data.tooth!.name}'),
                          Text('ລາຄາລວມ: ${fm.format(data.price)} ກິບ'),
                          Text(
                              'ສ່ວນຫຼຸດ: ${data.promotion != null ? data.promotion!.discount.toString() + '%' : 'ບໍ່ມີສ່ວນຫຼຸດ'}'),
                          Text(
                              'ວັນທີນັດໝາຍ: ${fmdate.format(DateTime.parse(detail != null ? detail!.date : DateTime.now().toString()))}  ${fmtime.format(DateTime.parse(detail != null ? detail!.date : DateTime.now().toString()))}'),
                        ],
                      ),
                      const Divider(color: primaryColor, height: 2),
                      Expanded(
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 20,
                              headingRowHeight: 40,
                              columns: menuDetailsColumn(context),
                              rows: List<DataRow>.generate(
                                  data.reserveDetail!.length, (index) {
                                return DataRow(cells: <DataCell>[
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(
                                      data.reserveDetail![index].detail,
                                      maxLines: 5,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis)),
                                  DataCell(Text(
                                      '${fm.format(data.reserveDetail![index].price)} ກິບ')),
                                  DataCell(Text(fmdate.format(DateTime.parse(
                                      data.reserveDetail![index].date)))),
                                  DataCell(Text(
                                      data.reserveDetail![index].isStatus ==
                                              'pending'
                                          ? "ຍັງບໍ່ໄດ້ຊຳລະ"
                                          : "ຊຳລະແລ້ວ")),
                                ]);
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Future showPaid(double price) {
    final priceController = TextEditingController();
    String warning = '';
    double moneyChange = 0;
    return showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (_context, mySetState) {
            return AlertDialog(
              title: const Text('ການຊຳລະ'),
              content: SizedBox(
                height: 170,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ລາຄາທັງໝົດ: ${fm.format(price)} ກິບ'),
                    Component(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: BorderRadius.circular(radius),
                      margin: EdgeInsets.zero,
                      child: TextField(
                        controller: priceController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (convertPattenTodouble(priceController.text) >
                                price) {
                              moneyChange =
                                  convertPattenTodouble(priceController.text) -
                                      price;
                              mySetState(() {});
                            }
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          moneyChange < 0
                              ? ''
                              : "ເງິນຖອນ: ${fm.format(moneyChange)} ກິບ",
                          style: title),
                    ),
                    Text(warning.isEmpty ? '' : warning, style: errorText)
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width / 3, 48)),
                    onPressed: () async {
                      Navigator.pop(_context);
                    },
                    child: const Text('ຍົກເລີກ')),
                const SizedBox(width: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width / 3, 48)),
                    onPressed: () async {
                      if (convertPattenTodouble(priceController.text) < price) {
                        mySetState(() {
                          warning = 'ຈຳນວນເງິນໜ້ອຍກວ່າລາຄາທັງໝົດ';
                        });
                        return;
                      }
                      Navigator.pop(context);
                      myProgress(context, null);
                      await ReserveModel.payReserve(
                              reserveId: data.id ?? 0, payPrice: data.price)
                          .then((value) {
                        if (value.code == 200) {
                          Navigator.pop(context);
                          showCompletedDialog(
                                  context: context,
                                  title: 'ສຳເລັດການປິ່ນປົວ',
                                  content: value.message ?? "ການຊຳລະສຳເລັດແລ້ວ")
                              .then((value) => {Navigator.pop(context)});
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
                    child: const Text('ຢຶນຢັ້ນ'))
              ],
            );
          });
        });
  }
}

List<DataColumn> menuDetailsColumn(BuildContext context) {
  return <DataColumn>[
    const DataColumn(label: Text('ລ/ດ', style: title)),
    const DataColumn(label: Text('ລາຍລະອຽດ', style: title)),
    const DataColumn(label: Text('ລາຄາ', style: title)),
    const DataColumn(label: Text('ວັນທີ', style: title)),
    const DataColumn(label: Text('ສະຖານະ', style: title)),
  ];
}
