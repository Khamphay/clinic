import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/model/reserve_detail_model.dart';
import 'package:clinic/provider/bloc/reserve_bloc.dart';
import 'package:clinic/provider/event/reserve_event.dart';
import 'package:clinic/provider/state/reserve_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NextReservePage extends StatefulWidget {
  const NextReservePage({Key? key, required this.reserveId, this.data})
      : super(key: key);

  final int reserveId;
  final ReserveDetailModel? data;

  @override
  State<NextReservePage> createState() => _NextReservePageState();
}

class _NextReservePageState extends State<NextReservePage> {
  TimeOfDay selectedTime = TimeOfDay.now();
  final detailController = TextEditingController();
  final priceController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<ReserveBloc, ReserveState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(title: const Text("ຊຳລະ ແລະ ນັດໝາຍຄັ້ງຕໍ່ໄປ")),
          body: SingleChildScrollView(
            child: Container(
              width: size.width,
              // height: size.height,
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Component(
                  height: 50,
                  width: size.width,
                  child: Center(
                    child: Text(
                        'ຄ່າປິ່ນປົວໃນຄັ້ງນີ້: ${fm.format(widget.data!.price)} ກິບ',
                        style: title),
                  ),
                ),
                Component(
                  borderRadius: BorderRadius.circular(10),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("ລາຍລະອຽດການນັດໝາຍຄັ້ງຕໍ່ໄປ", style: title),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Divider(color: primaryColor, height: 2),
                      ),
                      CustomContainer(
                          padding: const EdgeInsets.only(left: 10),
                          title: const Text("ຄ່າປິ່ນປົວ"),
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(
                            controller: priceController,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          )),
                      SizedBox(
                        height: 110,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: CustomContainer(
                                  height: 50,
                                  width: size.width / 2,
                                  title: const Text("ວັນທີນັດໝາຍ"),
                                  borderRadius: BorderRadius.circular(radius),
                                  child: TextFormField(
                                      controller: dateController,
                                      readOnly: true,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.only(left: 10),
                                          suffixIcon: IconButton(
                                              onPressed: () async {
                                                showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate: DateTime(
                                                            DateTime.now()
                                                                    .year +
                                                                1),
                                                        helpText: 'ເລືອກວັນທີ',
                                                        cancelText: 'ຍົກເລີກ',
                                                        confirmText: 'ຕົກລົງ')
                                                    .then((value) {
                                                  setState(() {
                                                    dateController.text =
                                                        fmdate.format(value ??
                                                            DateTime.now());
                                                  });
                                                });
                                              },
                                              icon: const Icon(
                                                  Icons.date_range))))),
                            ),
                            Flexible(
                              child: CustomContainer(
                                  height: 50,
                                  width: size.width / 2,
                                  title: const Text("ເວລານັດໝາຍ"),
                                  borderRadius: BorderRadius.circular(radius),
                                  child: TextFormField(
                                      controller: timeController,
                                      readOnly: true,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.only(left: 10),
                                          suffixIcon: IconButton(
                                              onPressed: () async {
                                                _selectTime(context);
                                              },
                                              icon: const Icon(
                                                  Icons.date_range))))),
                            ),
                          ],
                        ),
                      ),
                      CustomContainer(
                          padding: const EdgeInsets.only(left: 10),
                          title: const Text("ລາຍລະອຽດ"),
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(
                            controller: detailController,
                            maxLines: 5,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      child: const Text('ບັນທຶກ'),
                      onPressed: () {
                        final data = ReserveDetailModel(
                          reserveId: widget.reserveId,
                          date: '${dateController.text} ${timeController.text}',
                          price: convertPattenTodouble(priceController.text),
                          discountPrice:
                              convertPattenTodouble(priceController.text),
                          detailPrice:
                              convertPattenTodouble(priceController.text),
                          detail: detailController.text,
                        );

                        saveNextReserve(data);
                      }),
                )
              ]),
            ),
          ),
        );
      },
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      confirmText: 'ຕົກລົງ',
      cancelText: 'ຍົກເລີກ',
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        timeController.text = '${selectedTime.hour}:${selectedTime.minute}';
      });
    }
  }

  void saveNextReserve(ReserveDetailModel data) async {
    myProgress(context, null);

    await ReserveDetailModel.paidReserveDetail(detailId: widget.data!.id ?? 0)
        .then((paid) async {
      await ReserveDetailModel.postNextReserve(data: data).then((value) async {
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ບັນທືກ',
                content: 'ບັນທືກການນັດໝາຍສຳເລັດແລ້ວ')
            .then((value) {
          context.read<ReserveBloc>().add(FetchAllReserve(status: 'pending'));
          Navigator.pop(context, true);
        });
      }).catchError((e) {
        Navigator.pop(context);
        showFailDialog(
            context: context, title: 'ບັນທືກ', content: e.toString());
      });
    }).catchError((e) {
      Navigator.pop(context);
      showFailDialog(context: context, title: 'ບັນທືກ', content: e.toString());
    });
  }
}
