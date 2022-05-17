import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/model/promotion_model.dart';
import 'package:clinic/provider/bloc/promotion_bloc.dart';
import 'package:clinic/provider/event/promotion_event.dart';
import 'package:clinic/provider/state/promotion_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class PromotionFormEditor extends StatefulWidget {
  const PromotionFormEditor(
      {Key? key, required this.title, required this.edit, this.promotion})
      : super(key: key);
  final String title;
  final bool edit;
  final PromotionModel? promotion;

  @override
  State<PromotionFormEditor> createState() => _PromotionFormEditorState();
}

class _PromotionFormEditorState extends State<PromotionFormEditor> {
  final promotionController = TextEditingController();
  final detailController = TextEditingController();
  final startDateController = TextEditingController(text: '');
  final endDateController = TextEditingController(text: '');
  final discountController = TextEditingController(text: '');
  String startDate = '', endDate = '';
  String warningName = '',
      warningDetail = '',
      discountWarning = '',
      startDateWarning = '',
      endDateWarning = '';
  File? image;
  final _picker = ImagePicker();

  @override
  void initState() {
    if (widget.edit && widget.promotion != null) {
      promotionController.text = widget.promotion!.name;
      detailController.text = widget.promotion!.detail;
      discountController.text = widget.promotion!.discount.toString();
      startDate = widget.promotion!.start;
      endDate = widget.promotion!.end;
      startDateController.text = fmdate.format(DateTime.parse(startDate));
      endDateController.text = fmdate.format(DateTime.parse(endDate));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionBloc, PromotionState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(title: Text(widget.title)),
          body: SingleChildScrollView(
              child: Component(
                  padding: const EdgeInsets.only(top: 5, left: 4, right: 4),
                  child: Column(
                    children: [
                      Component(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: InkWell(
                              onTap: () async {
                                await _choiceDialogImage();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: image != null
                                    ? Image.file(image!)
                                    : (widget.promotion != null &&
                                            widget.promotion!.image != null)
                                        ? CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: urlImg +
                                                "/${widget.promotion!.image}",
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget: (context, url,
                                                    error) =>
                                                const Icon(
                                                    Icons
                                                        .image_not_supported_outlined,
                                                    size: 100),
                                          )
                                        : const Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 100),
                              ))),
                      CustomContainer(
                          padding: const EdgeInsets.only(left: 10),
                          title: const Text("ຫົວຂໍ້ສ່ວນຫຼຸດ"),
                          errorMsg: warningName,
                          borderRadius: BorderRadius.circular(radius),
                          child: TextFormField(
                            controller: promotionController,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            onChanged: (value) {
                              setState(() {
                                value.isEmpty
                                    ? warningName = "ກະລຸນາປ້ອນຫົວຂໍ້ສ່ວນຫຼຸດ"
                                    : warningName = '';
                              });
                            },
                          )),
                      CustomContainer(
                          padding: const EdgeInsets.only(left: 10),
                          title: const Text("ເປີເຊັນສ່ວນຫຼຸດ(%)"),
                          errorMsg: discountWarning,
                          borderRadius: BorderRadius.circular(radius),
                          child: TextFormField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: InputBorder.none, suffix: Text("%")),
                            onChanged: (value) {
                              setState(() {
                                value.isEmpty
                                    ? discountWarning = "ກະລຸນາປ້ອນສ່ວນຫຼຸດ"
                                    : discountWarning = '';
                              });
                            },
                          )),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Expanded(
                          child: CustomContainer(
                              title: const Text("ເລີ່ມວັນທີ"),
                              errorMsg: startDateWarning,
                              borderRadius: BorderRadius.circular(radius),
                              child: TextFormField(
                                  controller: startDateController,
                                  readOnly: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  onChanged: (value) {
                                    value.isEmpty
                                        ? startDateWarning =
                                            "ວັນທີ່ເລີ່ມໂປຣໂມຊັນ"
                                        : startDateWarning = '';
                                  },
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
                                                        DateTime.now().year +
                                                            1),
                                                    helpText:
                                                        'ເລືອກວັນທີເລີ່ມໂປຣໂມຊັນ',
                                                    cancelText: 'ຍົກເລີກ',
                                                    confirmText: 'ຕົກລົງ')
                                                .then((value) {
                                              if (value != null) {
                                                if (endDate.isNotEmpty) {
                                                  if (DateTime.parse(endDate)
                                                      .isBefore(value)) {
                                                    mySnackBar(context,
                                                        'ວັນທີ່ສິ້ນສຸດໂປຣໂມຊັນຕ້ອງນ້ອຍກວ່າວັນທີເລີ່ມໂປຣໂມຊັນ');
                                                    return;
                                                  }
                                                }
                                                startDate = value.toString();
                                                startDateController.text =
                                                    fmdate.format(value);
                                                setState(() {});
                                              }
                                            });
                                          },
                                          icon:
                                              const Icon(Icons.date_range))))),
                        ),
                        Expanded(
                          child: CustomContainer(
                              title: const Text("ຫາວັນທີ"),
                              borderRadius: BorderRadius.circular(radius),
                              errorMsg: endDateWarning,
                              child: TextFormField(
                                  controller: endDateController,
                                  readOnly: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  onChanged: (value) {
                                    value.isEmpty
                                        ? endDateWarning =
                                            "ວັນທີ່ສິ້ນສຸດໂປຣໂມຊັນ"
                                        : endDateWarning = '';
                                  },
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
                                                        DateTime.now().year +
                                                            1),
                                                    helpText:
                                                        'ເລືອກວັນທີສິ້ນສຸດໂປຣໂມຊັນ',
                                                    cancelText: 'ຍົກເລີກ',
                                                    confirmText: 'ຕົກລົງ')
                                                .then((value) {
                                              if (value != null) {
                                                if (startDate.isNotEmpty) {
                                                  if (DateTime.parse(startDate)
                                                      .isAfter(value)) {
                                                    mySnackBar(context,
                                                        'ວັນທີ່ສິ້ນສຸດໂປຣໂມຊັນຕ້ອງນ້ອຍກວ່າວັນທີເລີ່ມໂປຣໂມຊັນ');
                                                    return;
                                                  }
                                                }
                                                endDate = value.toString();
                                                endDateController.text =
                                                    fmdate.format(value);
                                                setState(() {});
                                              }
                                            });
                                          },
                                          icon:
                                              const Icon(Icons.date_range))))),
                        ),
                      ]),
                      CustomContainer(
                          height: 200,
                          padding: const EdgeInsets.only(left: 10),
                          title: const Text("ລາຍລະອຽດສ່ວນຫຼຸດ"),
                          errorMsg: warningDetail,
                          borderRadius: BorderRadius.circular(radius),
                          child: TextFormField(
                            maxLines: 10,
                            controller: detailController,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            onChanged: (value) {
                              setState(() {
                                value.isEmpty
                                    ? warningDetail =
                                        "ກະລຸນາປ້ອນລາຍລະອຽດສ່ວນຫຼຸດ"
                                    : warningDetail = '';
                              });
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30, left: 10, bottom: 10, right: 10),
                        child: ElevatedButton(
                            onPressed: () {
                              if (promotionController.text.isEmpty ||
                                  detailController.text.isEmpty ||
                                  discountController.text.isEmpty ||
                                  startDateController.text.isEmpty ||
                                  endDateController.text.isEmpty) {
                                promotionController.text.isEmpty
                                    ? warningName = "ກະລຸນາປ້ອນຫົວຂໍ້ສ່ວນຫຼຸດ"
                                    : warningName = '';
                                detailController.text.isEmpty
                                    ? warningDetail =
                                        "ກະລຸນາປ້ອນລາຍລະອຽດສ່ວນຫຼຸດ"
                                    : warningDetail = '';
                                discountController.text.isEmpty
                                    ? discountWarning = "ກະລຸນາປ້ອນສ່ວນຫຼຸດ"
                                    : discountWarning = '';
                                startDateController.text.isEmpty
                                    ? startDateWarning = "ວັນທີ່ເລີ່ມໂປຣໂມຊັນ"
                                    : startDateWarning = '';
                                endDateController.text.isEmpty
                                    ? endDateWarning = "ວັນທີ່ສິ້ນສຸດໂປຣໂມຊັນ"
                                    : endDateWarning = '';
                                setState(() {});
                                return;
                              }
                              final data = PromotionModel(
                                  id: widget.promotion != null
                                      ? widget.promotion!.id
                                      : null,
                                  name: promotionController.text,
                                  detail: detailController.text,
                                  start:
                                      sqldate.format(DateTime.parse(startDate)),
                                  end: sqldate.format(DateTime.parse(endDate)),
                                  discount: int.parse(discountController.text),
                                  file: image);
                              if (widget.edit && widget.promotion != null) {
                                updatePromotion(data);
                              } else {
                                addNewPromotion(data);
                              }
                              setState(() {
                                warningName = "";
                              });
                            },
                            child: const Text('ບັນທືກ')),
                      )
                    ],
                  ))),
        );
      },
    );
  }

  Future<ImageSource?> _choiceDialogImage() {
    return showDialog<ImageSource>(
        context: context,
        builder: (_context) {
          return AlertDialog(
            content: SizedBox(
              height: 100,
              width: 40,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _pickerImage(ImageSource.camera);
                              },
                              icon: const Icon(Icons.camera_alt_rounded,
                                  color: primaryColor)),
                          const Text("ກ້ອງຖ່າຍ"),
                        ],
                      )),
                  const Spacer(),
                  Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _pickerImage(ImageSource.gallery);
                              },
                              icon: const Icon(Icons.image_rounded,
                                  color: primaryColor)),
                          const Text('ຮູບພາບ'),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }

  Future<void> _pickerImage(ImageSource source) async {
    final pick = await _picker.pickImage(source: source);
    if (pick != null) {
      try {
        image = File(pick.path);
        setState(() {});
      } on Exception {
        // exception
      }
    }
  }

  void addNewPromotion(PromotionModel data) async {
    myProgress(context, null);
    await PromotionModel.postPromotion(data: data).then((add) {
      if (add.code == 201) {
        promotionController.clear();
        detailController.clear();
        discountController.clear();
        startDateController.clear();
        endDateController.clear();
        startDate = '';
        endDate = '';
        image = null;
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ບັນທືກ',
                content: 'ບັນທືກຂໍ້ມູນສຳເລັດແລ້ວ')
            .then(
                (value) => context.read<PromotionBloc>().add(FetchPromotion()));
      } else {
        Navigator.pop(context);
        showFailDialog(
            context: context,
            title: 'ບັນທືກ',
            content: add.error ?? 'ບັນທືກຂໍ້ມູນບໍ່ສຳເລັດ');
      }
    }).catchError((onError) {
      Navigator.pop(context);
      showFailDialog(
          context: context, title: 'ບັນທືກ', content: onError.toString());
    });
  }

  void updatePromotion(PromotionModel data) async {
    myProgress(context, null);
    await PromotionModel.putPromotion(data: data).then((update) {
      if (update.code == 200) {
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ແກ້ໄຂ',
                content: 'ແກ້ໄຂຂໍ້ມູນສຳເລັດແລ້ວ')
            .then((value) {
          context.read<PromotionBloc>().add(FetchPromotion());
          Navigator.pop(context);
        });
      } else {
        Navigator.pop(context);
        showFailDialog(
            context: context,
            title: 'ແກ້ໄຂ',
            content: update.error ?? 'ແກ້ໄຂຂໍ້ມູນບໍ່ສຳເລັດ');
      }
    }).catchError((onError) {
      Navigator.pop(context);
      showFailDialog(
          context: context, title: 'ແກ້ໄຂ', content: onError.toString());
    });
  }
}
