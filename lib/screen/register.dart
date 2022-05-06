import 'dart:io';

import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/model/profile_model.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final birthDateController = TextEditingController(text: '');
  final firstNameController = TextEditingController(text: '');
  final lastNameController = TextEditingController(text: '');
  final phoneController = TextEditingController(text: '');
  final villageController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  final rePasswordController = TextEditingController(text: '');
  String warningPass = '', warningRePass = '';
  int provinceId = 0, districtId = 0;
  File? image;
  final _picker = ImagePicker();
  int _gropRadioVal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child:
                    SvgPicture.asset("assets/images/writer.svg", height: 150),
              ),
              SizedBox(
                  // height: 10,
                  child: Text("ລົງທະບຽນ",
                      style: Theme.of(context).textTheme.headline1)),
              _buildForm(),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 28),
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text("ລົງທະບຽນ")))
            ],
          ),
        ));
  }

  Widget _buildForm() {
    return Form(
      child: CustomContainer(
          padding: const EdgeInsets.only(top: 20),
          borderRadius: BorderRadius.circular(radius),
          child: Column(
            children: [
              CustomContainer(
                  height: 200,
                  width: 200,
                  title: const Text(""),
                  borderRadius: BorderRadius.circular(radius),
                  child: InkWell(
                    onTap: () async {
                      await _choiceDialogImage();
                    },
                    child: const Center(
                        child: Icon(Icons.account_circle_outlined, size: 100)),
                  )),
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
                          const Text("ຊາຍ")
                        ]),
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
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now(),
                                        helpText: 'ເລືອກວັນທີເດືອນປີເກີດ',
                                        cancelText: 'ຍົກເລີກ',
                                        confirmText: 'ຕົກລົງ')
                                    .then((value) {
                                  setState(() {
                                    birthDateController.text =
                                        fmdate.format(value ?? DateTime.now());
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
              CustomContainer(
                  title: const Text("ແຂວງ"),
                  borderRadius: BorderRadius.circular(radius),
                  child: DropdownSearch<String>(
                      mode: Mode.DIALOG,
                      showSearchBox: true,
                      maxHeight: MediaQuery.of(context).size.height / 1.4,
                      searchFieldProps: const TextFieldProps(
                          decoration: InputDecoration(
                              helperText: 'ເລືອກແຂວງ',
                              hintText: 'ຄົ້ນຫາ',
                              suffixIcon: Icon(Icons.search_rounded))),
                      dropdownSearchDecoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0)),
                      items: [],
                      compareFn: (String? i, String? s) =>
                          (i == s) ? true : false,
                      onChanged: (value) {})),
              CustomContainer(
                  title: const Text("ເມືອງ"),
                  borderRadius: BorderRadius.circular(radius),
                  child: DropdownSearch<String>(
                      mode: Mode.DIALOG,
                      showSearchBox: true,
                      maxHeight: MediaQuery.of(context).size.height / 1.4,
                      searchFieldProps: const TextFieldProps(
                          decoration: InputDecoration(
                              helperText: 'ເລືອກເມືອງ',
                              hintText: 'ຄົ້ນຫາ',
                              suffixIcon: Icon(Icons.search_rounded))),
                      dropdownSearchDecoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(12, 0, 0, 0)),
                      items: [],
                      compareFn: (String? i, String? s) =>
                          (i == s) ? true : false,
                      onChanged: (value) {})),
              CustomContainer(
                  title: const Text("ລະຫັດຜ່ານ"),
                  borderRadius: BorderRadius.circular(radius),
                  errorMsg: warningPass,
                  child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.security_rounded),
                      ),
                      onChanged: (value) {
                        (value.length < 6)
                            ? warningPass == 'ລະຫັດຜ່ານຕ້ອງຫຼາຍກວ່າ 6 ຕົວເລກ'
                            : warningPass = '';
                        setState(() {});
                      })),
              CustomContainer(
                  title: const Text("ລະຫັດຜ່ານ"),
                  borderRadius: BorderRadius.circular(radius),
                  errorMsg: warningRePass,
                  child: TextFormField(
                      obscureText: true,
                      controller: rePasswordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.security_rounded),
                      ),
                      onChanged: (String value) {
                        (value != passwordController.text)
                            ? warningRePass = 'ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ'
                            : warningRePass = '';

                        setState(() {});
                      })),
            ],
          )),
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
      } on Exception catch (e) {}
    }
  }

  void adduser() async {
    try {
      final user = ProfileModel(
          userId: '',
          firstname: firstNameController.text,
          lastname: lastNameController.text,
          gender: _gropRadioVal == 0 ? 'M' : 'F',
          birthDate: birthDateController.text,
          phone: phoneController.text,
          file: image,
          districtId: districtId,
          provinceId: provinceId,
          roles: [],
          village: villageController.text);

      final add = await ProfileModel.registerMember(data: user);
    } on Exception catch (e) {
      // TODO
    }
  }
}
