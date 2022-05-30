import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/controller/customcontainer.dart';
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
  @override
  void initState() {
    data = widget.data;
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
          child: SingleChildScrollView(
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
                          Text('ເມືອງ: ${data.user!.profile.district!.name}'),
                          Text('ແຂວງ: ${data.user!.profile.province!.name}'),
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
                    Text('ແຂ້ວ: ${data.tooth!.name}'),
                    Text('ລາຄາ: ${fm.format(data.price)} ກິບ'),
                    Text(
                        'ສ່ວນຫຼຸດ: ${data.promotion != null ? data.promotion!.discount.toString() + '%' : 'ບໍ່ມີສ່ວນຫຼຸດ'}'),
                    Text(
                        'ວັນທີນັດໝາຍ: ${fmdate.format(DateTime.parse(data.startDate))}'),
                  ],
                ),
                const Divider(color: primaryColor),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Flexible(
                      child: ElevatedButton(
                          onPressed: () async {
                            await showPaid(data);
                          },
                          child: const Text('ຊຳລະ'))),
                  const SizedBox(width: 10),
                  Flexible(
                    child: ElevatedButton(
                        onPressed: () {}, child: const Text('ນັດໝາຍຄັ້ງຕໍ່ໄປ')),
                  )
                ])
              ],
            ),
          ))),
    );
  }

  Future showPaid(ReserveModel data) {
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
                    Text('ລາຄາທັງໝົດ: ${fm.format(data.price)} ກິບ'),
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
                                data.price) {
                              moneyChange =
                                  convertPattenTodouble(priceController.text) -
                                      data.price;
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
                      if (convertPattenTodouble(priceController.text) <
                          data.price) {
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
