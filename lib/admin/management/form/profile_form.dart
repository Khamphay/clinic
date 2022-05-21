import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/model/district_model.dart';
import 'package:clinic/model/profile_model.dart';
import 'package:clinic/model/province_model.dart';
import 'package:clinic/model/user_model.dart';
import 'package:clinic/provider/bloc/district_bloc.dart';
import 'package:clinic/provider/bloc/province_bloc.dart';
import 'package:clinic/provider/event/district_event.dart';
import 'package:clinic/provider/event/province_event.dart';
import 'package:clinic/provider/state/district_state.dart';
import 'package:clinic/provider/state/province_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileFrom extends StatefulWidget {
  const EditProfileFrom({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  State<EditProfileFrom> createState() => _EditProfileFromState();
}

class _EditProfileFromState extends State<EditProfileFrom> {
  final birthDateController = TextEditingController(text: '');
  final firstNameController = TextEditingController(text: '');
  final lastNameController = TextEditingController(text: '');
  final phoneController = TextEditingController(text: '');
  final villageController = TextEditingController(text: '');
  String warningPass = '', warningRePass = '';
  int provinceId = 0, districtId = 0;
  File? image;
  final _picker = ImagePicker();
  int _gropRadioVal = 0;

  @override
  void initState() {
    firstNameController.text = widget.user.profile.firstname;
    lastNameController.text = widget.user.profile.lastname;
    phoneController.text = widget.user.phone;
    villageController.text = widget.user.profile.village;
    provinceId = widget.user.profile.provinceId;
    districtId = widget.user.profile.districtId;
    birthDateController.text =
        fmdate.format(DateTime.parse(widget.user.profile.birthDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: const Text("ແກ້ໄຂໂປຣໄຟ")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildForm(),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 28),
                  child: ElevatedButton(
                      onPressed: () {
                        editUser();
                      },
                      child: const Text("ບັນທືກ")))
            ],
          ),
        ));
  }

  Widget _buildForm() {
    return BlocBuilder<ProvinceBloc, ProvinceState>(
      builder: (_, state) {
        if (state is ProvinceInitialState) {
          context.read<ProvinceBloc>().add(FetchProvince());
        }
        return Form(
          child: CustomContainer(
              padding: const EdgeInsets.only(top: 20),
              borderRadius: BorderRadius.circular(radius),
              child: Column(
                children: [
                  Component(
                      height: 220,
                      width: 220,
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                          onTap: () async {
                            await _choiceDialogImage();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: image != null
                                ? Image.file(image!)
                                : image == null
                                    ? CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: urlImg +
                                            "/${widget.user.profile.image}",
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )
                                    : const Icon(Icons.fastfood_rounded,
                                        size: 60),
                          ))),
                  CustomContainer(
                      title: const Text("ຊື່"),
                      borderRadius: BorderRadius.circular(radius),
                      child: TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.account_circle_outlined),
                        ),
                      )),
                  CustomContainer(
                      title: const Text("ນາມສະກຸນ"),
                      borderRadius: BorderRadius.circular(radius),
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.account_circle_outlined),
                        ),
                      )),
                  CustomContainer(
                      title: const Text("ເພດ"),
                      borderRadius: BorderRadius.circular(radius),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(children: [
                              Radio(
                                  value: 0,
                                  activeColor: primaryColor,
                                  groupValue: _gropRadioVal,
                                  onChanged: (int? value) {
                                    if (value != null) {
                                      setState(() {
                                        _gropRadioVal = value;
                                      });
                                    }
                                  }),
                              const Text("ຊາຍ")
                            ]),
                            Row(children: [
                              Radio(
                                  value: 1,
                                  activeColor: primaryColor,
                                  groupValue: _gropRadioVal,
                                  onChanged: (int? value) {
                                    if (value != null) {
                                      setState(() {
                                        _gropRadioVal = value;
                                      });
                                    }
                                  }),
                              const Text('ຍິງ')
                            ])
                          ])),
                  CustomContainer(
                      title: const Text("ວັນທີເດືອນປີເກີດ"),
                      borderRadius: BorderRadius.circular(radius),
                      child: TextFormField(
                          controller: birthDateController,
                          readOnly: true,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(left: 10),
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(
                                                DateTime.now().year - 50),
                                            lastDate: DateTime.now(),
                                            helpText: 'ເລືອກວັນທີເດືອນປີເກີດ',
                                            cancelText: 'ຍົກເລີກ',
                                            confirmText: 'ຕົກລົງ')
                                        .then((value) {
                                      setState(() {
                                        birthDateController.text = fmdate
                                            .format(value ?? DateTime.now());
                                      });
                                    });
                                  },
                                  icon: const Icon(Icons.date_range))))),
                  CustomContainer(
                      title: const Text("ເບີໂທລະສັບ"),
                      borderRadius: BorderRadius.circular(radius),
                      child: TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.phone_in_talk_outlined),
                        ),
                      )),
                  CustomContainer(
                      title: const Text("ບ້ານ"),
                      borderRadius: BorderRadius.circular(radius),
                      child: TextFormField(
                        controller: villageController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.location_history_sharp),
                        ),
                      )),
                  Builder(builder: (context) {
                    if (state is ProvinceLoadCompleteState) {
                      return _buildDropdowProvince(state.provinces);
                    } else {
                      return _buildDropdowProvince([]);
                    }
                  }),
                  BlocBuilder<DistrictBloc, DistrictState>(
                    builder: (context, state) {
                      if (state is DistrictLoadCompleteState) {
                        return _buildDropdowDistrict(state.districts);
                      } else {
                        return _buildDropdowDistrict([]);
                      }
                    },
                  ),
                ],
              )),
        );
      },
    );
  }

  Widget _buildDropdowDistrict(List<DistrictModel> districts) {
    return CustomContainer(
        title: const Text("ເມືອງ"),
        borderRadius: BorderRadius.circular(radius),
        padding: const EdgeInsets.only(left: 10),
        child: DropdownSearch<String>(
            mode: Mode.DIALOG,
            showSearchBox: true,
            showSelectedItems: true,
            selectedItem: widget.user.profile.district!.name,
            maxHeight: MediaQuery.of(context).size.height / 1.4,
            searchFieldProps: const TextFieldProps(
                decoration: InputDecoration(
                    helperText: 'ເລືອກເມືອງ',
                    hintText: 'ຄົ້ນຫາ',
                    suffixIcon: Icon(Icons.search_rounded))),
            dropdownSearchDecoration:
                const InputDecoration(border: InputBorder.none),
            items: districts.map((e) => e.name).toList(),
            compareFn: (String? i, String? s) => (i == s) ? true : false,
            onChanged: (value) {
              for (var element in districts) {
                if (element.name == value) {
                  districtId = element.id ?? 0;
                  return;
                }
              }
            }));
  }

  Widget _buildDropdowProvince(List<ProvinceModel> provinces) {
    return CustomContainer(
        title: const Text("ແຂວງ"),
        borderRadius: BorderRadius.circular(radius),
        padding: const EdgeInsets.only(left: 10),
        child: DropdownSearch<String>(
            mode: Mode.DIALOG,
            showSearchBox: true,
            showSelectedItems: true,
            selectedItem: widget.user.profile.province!.name,
            maxHeight: MediaQuery.of(context).size.height / 1.4,
            searchFieldProps: const TextFieldProps(
                decoration: InputDecoration(
                    helperText: 'ເລືອກແຂວງ',
                    hintText: 'ຄົ້ນຫາ',
                    suffixIcon: Icon(Icons.search_rounded))),
            dropdownSearchDecoration:
                const InputDecoration(border: InputBorder.none),
            items: provinces.map((e) => e.name).toList(),
            compareFn: (String? i, String? s) => (i == s) ? true : false,
            onChanged: (value) {
              for (var element in provinces) {
                if (element.name == value) {
                  provinceId = element.id ?? 0;
                  context
                      .read<DistrictBloc>()
                      .add(FetchDistrict(provinceId: provinceId));
                  return;
                }
              }
            }));
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

  void editUser() async {
    myProgress(context, null);
    try {
      final user = ProfileModel(
          userId: userId,
          firstname: firstNameController.text,
          lastname: lastNameController.text,
          gender: _gropRadioVal == 0 ? 'M' : 'F',
          birthDate: birthDateController.text,
          phone: phoneController.text,
          file: image,
          districtId: districtId,
          provinceId: provinceId,
          roles: widget.user.roles,
          village: villageController.text);

      await ProfileModel.editUser(data: user).then((value) {
        if (value.code == 200) {
          Navigator.pop(context);
          showCompletedDialog(
                  context: context,
                  title: 'ແກ້ໄຂ',
                  content: 'ແກ້ໄຂໂປຣໄຟສຳເລັດແລ້ວ')
              .then((value) => Navigator.pop(context));
        } else {
          Navigator.pop(context);
          showFailDialog(
              context: context, title: 'ແກ້ໄຂ', content: 'ແກ້ໄຂໂປຣໄຟບໍ່ສຳເລັດ');
        }
      }).catchError((e) {
        Navigator.pop(context);
        showFailDialog(context: context, title: 'ແກ້ໄຂ', content: e.toString());
      });
    } on Exception catch (e) {
      Navigator.pop(context);
      showFailDialog(context: context, title: 'ແກ້ໄຂ', content: e.toString());
    }
  }
}
