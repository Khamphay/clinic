import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/model/tooth_model.dart';
import 'package:clinic/provider/bloc/tooth_bloc.dart';
import 'package:clinic/provider/event/tooth_event.dart';
import 'package:clinic/provider/state/tooth_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class ToothFormEditor extends StatefulWidget {
  const ToothFormEditor(
      {Key? key, required this.title, required this.edit, this.tooth})
      : super(key: key);
  final String title;
  final bool edit;
  final ToothModel? tooth;

  @override
  State<ToothFormEditor> createState() => _ToothFormEditorState();
}

class _ToothFormEditorState extends State<ToothFormEditor> {
  final toothController = TextEditingController();
  final priceController = TextEditingController();
  String warningName = '', warningPrice = '';
  File? image;
  final _picker = ImagePicker();

  @override
  void initState() {
    if (widget.edit && widget.tooth != null) {
      toothController.text = widget.tooth!.name;
      priceController.text = "${widget.tooth!.startPrice}";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToothBloc, ToothState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(title: Text(widget.title)),
          body: SingleChildScrollView(
              child: Component(
                  padding: const EdgeInsets.only(
                      top: 20, left: 4, bottom: 10, right: 4),
                  child: Column(
                    children: [
                      Component(
                          height: 200,
                          width: 200,
                          child: InkWell(
                              onTap: () async {
                                await _choiceDialogImage();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: image != null
                                    ? Image.file(image!)
                                    : (widget.tooth != null &&
                                            widget.tooth!.image != null)
                                        ? CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: urlImg +
                                                "/${widget.tooth!.image}",
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
                          title: const Text("ຊື່ລາຍການແຂ້ວ"),
                          errorMsg: warningName,
                          borderRadius: BorderRadius.circular(radius),
                          child: TextFormField(
                            controller: toothController,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            onChanged: (value) {
                              setState(() {
                                value.isEmpty
                                    ? warningName = "ກະລຸນາປ້ອນຂໍ້ມູນແຂ້ວ"
                                    : warningName = '';
                              });
                            },
                          )),
                      CustomContainer(
                          padding: const EdgeInsets.only(left: 10),
                          title: const Text("ລາຄາ"),
                          errorMsg: warningPrice,
                          borderRadius: BorderRadius.circular(radius),
                          child: TextFormField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            onChanged: (value) {
                              setState(() {
                                value.isEmpty
                                    ? warningPrice = "ກະລຸນາປ້ອນລາຄາ"
                                    : warningPrice = '';
                              });
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30, left: 10, bottom: 10, right: 10),
                        child: ElevatedButton(
                            onPressed: () {
                              if (toothController.text.isEmpty ||
                                  priceController.text.isEmpty) {
                                toothController.text.isEmpty
                                    ? warningName = "ກະລຸນາປ້ອນຂໍ້ມູນແຂ້ວ"
                                    : warningName = '';
                                priceController.text.isEmpty
                                    ? warningPrice = "ກະລຸນາປ້ອນລາຄາ"
                                    : warningPrice = '';
                                setState(() {});
                                return;
                              }
                              final data = ToothModel(
                                  id: widget.tooth != null
                                      ? widget.tooth!.id
                                      : null,
                                  name: toothController.text,
                                  startPrice: convertPattenTodouble(
                                      priceController.text),
                                  file: image);
                              if (widget.edit && widget.tooth != null) {
                                updateTooth(data);
                              } else {
                                addNewTooth(data);
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
    int x, y, width, height;
    if (pick != null) {
      try {
        ImageProperties properties =
            await FlutterNativeImage.getImageProperties(pick.path);
        x = (properties.width! > 1024) ? (properties.width! - 1024) ~/ 2 : 0;
        y = (properties.height! > 1024) ? (properties.height! - 1024) ~/ 2 : 0;

        if (properties.width! > 1024 && properties.height! > 1024) {
          width = height = 1024;
        } else if (properties.width! > 1024 && properties.height! <= 1024) {
          width = height = properties.height!;
        } else if (properties.width! <= 1024 && properties.height! > 1024) {
          width = height = properties.width!;
        } else {
          width = properties.width!;
          height = properties.height!;
        }

        //Todo: Crop image with square
        image = await FlutterNativeImage.cropImage(
          pick.path,
          x,
          y,
          width,
          height,
        );

        setState(() {});
      } on Exception {
        // exception
      }
    }
  }

  void addNewTooth(ToothModel data) async {
    myProgress(context, null);
    await ToothModel.postTooth(data: data).then((add) {
      if (add.code == 201) {
        toothController.clear();
        priceController.clear();
        image = null;
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ບັນທືກ',
                content: 'ບັນທືກຂໍ້ມູນສຳເລັດແລ້ວ')
            .then((value) => context.read<ToothBloc>().add(FetchTooth()));
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

  void updateTooth(ToothModel data) async {
    myProgress(context, null);
    await ToothModel.putTooth(data: data).then((update) {
      if (update.code == 200) {
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ແກ້ໄຂ',
                content: 'ແກ້ໄຂຂໍ້ມູນສຳເລັດແລ້ວ')
            .then((value) {
          context.read<ToothBloc>().add(FetchTooth());
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
