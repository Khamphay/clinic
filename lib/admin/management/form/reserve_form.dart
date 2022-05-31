import 'package:clinic/alert/progress.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/model/promotion_model.dart';
import 'package:clinic/model/reserve_model.dart';
import 'package:clinic/model/tooth_model.dart';
import 'package:clinic/provider/bloc/promotion_bloc.dart';
import 'package:clinic/provider/bloc/reserve_bloc.dart';
import 'package:clinic/provider/bloc/tooth_bloc.dart';
import 'package:clinic/provider/event/promotion_event.dart';
import 'package:clinic/provider/event/reserve_event.dart';
import 'package:clinic/provider/event/tooth_event.dart';
import 'package:clinic/provider/state/promotion_state.dart';
import 'package:clinic/provider/state/reserve_state.dart';
import 'package:clinic/provider/state/tooth_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/size.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReserveFormPage extends StatefulWidget {
  const ReserveFormPage(
      {Key? key, required this.edit, this.tooth, this.reserve})
      : super(key: key);

  final bool edit;
  final ToothModel? tooth;
  final ReserveModel? reserve;

  @override
  State<ReserveFormPage> createState() => _ReserveFormPageState();
}

class _ReserveFormPageState extends State<ReserveFormPage> {
  String warning = '', toothName = '', promotionName = '';
  int? promotionId;
  int toothId = 0, discount = 0;
  double price = 0, discountPrice = 0;
  TimeOfDay selectedTime = TimeOfDay.now();
  final detailController = TextEditingController();
  final priceController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  Future _refreshPromotion() async {
    await Future.delayed(const Duration(seconds: 0));
    context.read<PromotionBloc>().add(FetchCustomerPromotion());
  }

  @override
  void initState() {
    _refreshPromotion();
    if (widget.tooth != null) {
      toothId = widget.tooth?.id ?? 0;
      priceController.text = '${fm.format(widget.tooth?.startPrice)} ກິບ';
      price = widget.tooth!.startPrice;
      toothName = widget.tooth!.name;
    }

    if (widget.reserve != null) {
      detailController.text = widget.reserve!.detail;
      discountPrice = widget.reserve!.discountPrice;
      dateController.text =
          fmdate.format(DateTime.parse(widget.reserve!.startDate));
      timeController.text =
          fmtime.format(DateTime.parse(widget.reserve!.startDate));
      if (widget.reserve!.promotion != null) {
        promotionId = widget.reserve!.promotion!.id;
        promotionName = widget.reserve!.promotion!.name;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<ReserveBloc, ReserveState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('ຈອງຄິວ')),
          body: SizedBox(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                BlocBuilder<ToothBloc, ToothState>(
                  builder: (context, state) {
                    if (state is ToothInitialState) {
                      context.read<ToothBloc>().add(FetchTooth());
                    }
                    if (state is ToothLoadCompleteState) {
                      return _buildDropdowTooth(state.tooths);
                    } else {
                      return _buildDropdowTooth([]);
                    }
                  },
                ),
                CustomContainer(
                    padding: const EdgeInsets.only(left: 10),
                    title: const Text("ລາຄາແຂ້ວ"),
                    errorMsg: warning,
                    borderRadius: BorderRadius.circular(10),
                    child: TextFormField(
                      controller: priceController,
                      readOnly: true,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    )),
                BlocBuilder<PromotionBloc, PromotionState>(
                  builder: (context, state) {
                    if (state is PromotionInitialState) {
                      context
                          .read<PromotionBloc>()
                          .add(FetchCustomerPromotion());
                    }
                    if (state is CustomerPromotionLoadCompleteState) {
                      return _buildDropdowPromotion(state.promotions);
                    } else {
                      return _buildDropdowPromotion([]);
                    }
                  },
                ),
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
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(
                                                      DateTime.now().year + 1),
                                                  helpText: 'ເລືອກວັນທີ',
                                                  cancelText: 'ຍົກເລີກ',
                                                  confirmText: 'ຕົກລົງ')
                                              .then((value) {
                                            setState(() {
                                              dateController.text =
                                                  fmdate.format(
                                                      value ?? DateTime.now());
                                            });
                                          });
                                        },
                                        icon: const Icon(Icons.date_range))))),
                      ),
                      Flexible(
                        child: CustomContainer(
                            height: 50,
                            width: size.width / 2,
                            title: const Text("ເວລາ"),
                            borderRadius: BorderRadius.circular(radius),
                            child: TextFormField(
                                controller: timeController,
                                readOnly: true,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          _selectTime(context);
                                        },
                                        icon: const Icon(Icons.date_range))))),
                      ),
                    ],
                  ),
                ),
                CustomContainer(
                    padding: const EdgeInsets.only(left: 10),
                    title: const Text("ລາຍລະອຽດ"),
                    errorMsg: warning,
                    borderRadius: BorderRadius.circular(10),
                    child: TextFormField(
                      controller: detailController,
                      maxLines: 5,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    )),
                ElevatedButton(
                    child: const Text('ຈອງຄິວ'),
                    onPressed: () {
                      final data = ReserveModel(
                        toothId: toothId,
                        startDate:
                            '${dateController.text} ${timeController.text}',
                        date: '${dateController.text} ${timeController.text}',
                        price: price,
                        discountPrice: discountPrice,
                        detailPrice: price,
                        detail: detailController.text,
                        promotionId: promotionId,
                      );

                      saveReserve(data);
                    })
              ]),
            )),
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

  Widget _buildDropdowPromotion(List<PromotionModel> promotions) {
    return CustomContainer(
        height: 50,
        title: const Text("ໂປຣໂມຊັນ"),
        borderRadius: BorderRadius.circular(radius),
        padding: const EdgeInsets.only(left: 10),
        child: DropdownSearch<String>(
            mode: Mode.DIALOG,
            showSearchBox: true,
            showSelectedItems: widget.edit,
            selectedItem: widget.edit ? promotionName : null,
            maxHeight: MediaQuery.of(context).size.height / 1.4,
            searchFieldProps: const TextFieldProps(
                decoration: InputDecoration(
                    helperText: 'ເລືອກໂປຣໂມຊັນ',
                    hintText: 'ຄົ້ນຫາ',
                    suffixIcon: Icon(Icons.search_rounded))),
            dropdownSearchDecoration:
                const InputDecoration(border: InputBorder.none),
            items: promotions
                .map((e) => '${e.name} ຫຼຸດສູງສຸດ: ${e.discount}%')
                .toList(),
            compareFn: (String? i, String? s) => (i == s) ? true : false,
            onChanged: (value) {
              for (var element in promotions) {
                if ('${element.name} ຫຼຸດສູງສຸດ: ${element.discount}%' ==
                    value) {
                  promotionId = element.id ?? 0;
                  discount = element.discount;
                  discountPrice = (price * (element.discount / 100));
                  priceController.text =
                      '${fm.format(price - discountPrice)} ກິບ';
                  setState(() {});
                  return;
                }
              }
            }));
  }

  Widget _buildDropdowTooth(List<ToothModel> tooths) {
    return CustomContainer(
        height: 50,
        title: const Text("ຂໍ້ມູນແຂ້ວ"),
        borderRadius: BorderRadius.circular(radius),
        padding: const EdgeInsets.only(left: 10),
        child: DropdownSearch<String>(
            mode: Mode.DIALOG,
            showSearchBox: true,
            showSelectedItems: toothName.isNotEmpty ? true : false,
            selectedItem: toothName.isNotEmpty ? toothName : null,
            maxHeight: MediaQuery.of(context).size.height / 1.4,
            searchFieldProps: const TextFieldProps(
                decoration: InputDecoration(
                    helperText: 'ເລືອກແຂ້ວ',
                    hintText: 'ຄົ້ນຫາ',
                    suffixIcon: Icon(Icons.search_rounded))),
            dropdownSearchDecoration:
                const InputDecoration(border: InputBorder.none),
            items: tooths.map((e) => e.name).toList(),
            compareFn: (String? i, String? s) => (i == s) ? true : false,
            onChanged: (value) {
              for (var element in tooths) {
                if (element.name == value) {
                  toothId = element.id ?? 0;
                  price = element.startPrice;
                  discountPrice = (price * (discount / 100));
                  priceController.text =
                      '${fm.format(price - discountPrice)} ກິບ';

                  setState(() {});
                  return;
                }
              }
            }));
  }

  void saveReserve(ReserveModel data) async {
    myProgress(context, null);
    await ReserveModel.postReserve(data: data).then((value) async {
      Navigator.pop(context);
      showCompletedDialog(
              context: context,
              title: 'ບັນທືກ',
              content: 'ບັນທືກການຈອງຄິວສຳເລັດແລ້ວ')
          .then((value) {
        context.read<ReserveBloc>().add(FetchMemberReserve());
        Navigator.pop(context);
      });
    }).catchError((e) {
      Navigator.pop(context);
      showFailDialog(context: context, title: 'ບັນທືກ', content: e.toString());
    });
  }
}
