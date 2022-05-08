import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/model/post_model.dart';
import 'package:clinic/provider/bloc/post_bloc.dart';
import 'package:clinic/provider/event/post_event.dart';
import 'package:clinic/provider/state/post_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class PostFormEditor extends StatefulWidget {
  const PostFormEditor(
      {Key? key, required this.title, required this.edit, this.post})
      : super(key: key);
  final String title;
  final bool edit;
  final PostModel? post;

  @override
  State<PostFormEditor> createState() => _PostFormEditorState();
}

class _PostFormEditorState extends State<PostFormEditor> {
  final postController = TextEditingController();
  final detailController = TextEditingController();
  String warningName = '', warningDetail = '';
  File? image;
  final _picker = ImagePicker();

  @override
  void initState() {
    if (widget.edit && widget.post != null) {
      postController.text = widget.post!.name;
      detailController.text = widget.post!.detail;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
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
                                    : (widget.post != null &&
                                            widget.post!.image != null)
                                        ? CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: urlImg +
                                                "/${widget.post!.image}",
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
                          title: const Text("ຫົວຂໍ້ຂ່າວ"),
                          errorMsg: warningName,
                          borderRadius: BorderRadius.circular(radius),
                          child: TextFormField(
                            controller: postController,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            onChanged: (value) {
                              setState(() {
                                value.isEmpty
                                    ? warningName = "ກະລຸນາປ້ອນຫົວຂໍ້ຂ່າວ"
                                    : warningName = '';
                              });
                            },
                          )),
                      CustomContainer(
                          height: 200,
                          padding: const EdgeInsets.only(left: 10),
                          title: const Text("ລາຍລະອຽດຂ່າວ"),
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
                                    ? warningDetail = "ກະລຸນາປ້ອນລາຍລະອຽດຂ່າວ"
                                    : warningDetail = '';
                              });
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30, left: 10, bottom: 10, right: 10),
                        child: ElevatedButton(
                            onPressed: () {
                              if (postController.text.isEmpty ||
                                  detailController.text.isEmpty) {
                                postController.text.isEmpty
                                    ? warningName = "ກະລຸນາປ້ອນຫົວຂໍ້ຂ່າວ"
                                    : warningName = '';
                                detailController.text.isEmpty
                                    ? warningDetail = "ກະລຸນາປ້ອນລາຍລະອຽດຂ່າວ"
                                    : warningDetail = '';
                                setState(() {});
                                return;
                              }
                              final data = PostModel(
                                  name: postController.text,
                                  detail: detailController.text,
                                  file: image);
                              if (widget.edit && widget.post != null) {
                                updatePost(data);
                              } else {
                                addNewPost(data);
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

  void addNewPost(PostModel data) async {
    myProgress(context, null);
    await PostModel.postPost(data: data).then((add) {
      if (add.code == 201) {
        postController.clear();
        detailController.clear();
        image = null;
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ບັນທືກ',
                content: 'ບັນທືກຂໍ້ມູນສຳເລັດແລ້ວ')
            .then((value) => context.read<PostBloc>().add(FetchPost()));
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

  void updatePost(PostModel data) async {
    myProgress(context, null);
    await PostModel.putPost(data: data).then((update) {
      if (update.code == 200) {
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ແກ້ໄຂ',
                content: 'ແກ້ໄຂຂໍ້ມູນສຳເລັດແລ້ວ')
            .then((value) {
          context.read<PostBloc>().add(FetchPost());
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
