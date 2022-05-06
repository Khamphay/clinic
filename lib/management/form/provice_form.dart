import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/model/province_model.dart';
import 'package:clinic/provider/bloc/province_bloc.dart';
import 'package:clinic/provider/event/province_event.dart';
import 'package:clinic/provider/state/province_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/size.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProvinceFormEditor extends StatefulWidget {
  const ProvinceFormEditor(
      {Key? key, required this.title, required this.edit, this.province})
      : super(key: key);
  final String title;
  final bool edit;
  final ProvinceModel? province;

  @override
  State<ProvinceFormEditor> createState() => _ProvinceFormEditorState();
}

class _ProvinceFormEditorState extends State<ProvinceFormEditor> {
  final provinceController = TextEditingController();
  String section = sections[0], warning = '';

  @override
  void initState() {
    if (widget.edit && widget.province != null) {
      provinceController.text = widget.province!.name;
      section = widget.province!.section == 'north'
          ? sections[0]
          : widget.province!.section == 'center'
              ? sections[1]
              : sections[2];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProvinceBloc, ProvinceState>(
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
                      CustomContainer(
                          padding: const EdgeInsets.only(left: 10),
                          title: const Text("ຊື່ແຂວງ"),
                          errorMsg: warning,
                          borderRadius: BorderRadius.circular(radius),
                          child: TextFormField(
                            controller: provinceController,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          )),
                      CustomContainer(
                          title: const Text("ເລືອກພາກ"),
                          borderRadius: BorderRadius.circular(radius),
                          padding: const EdgeInsets.only(left: 10),
                          child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: true,
                              selectedItem: section,
                              maxHeight: MediaQuery.of(context).size.height / 3,
                              searchFieldProps: const TextFieldProps(
                                  decoration: InputDecoration(
                                      helperText: 'ເລືອກພາກ',
                                      suffixIcon: Icon(Icons.search_rounded))),
                              dropdownSearchDecoration: const InputDecoration(
                                  border: InputBorder.none),
                              items: sections,
                              compareFn: (String? i, String? s) =>
                                  (i == s) ? true : false,
                              onChanged: (value) {
                                section = value ?? 'center';
                              })),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30, left: 10, bottom: 10, right: 10),
                        child: ElevatedButton(
                            onPressed: () {
                              if (provinceController.text.isEmpty) {
                                warning = "ກະລຸນາປ້ອນຂໍ້ມູນແຂວງ";
                                setState(() {});
                              } else {
                                final data = ProvinceModel(
                                    id: widget.province != null
                                        ? widget.province!.id
                                        : null,
                                    name: provinceController.text,
                                    section: section == sections[0]
                                        ? 'north'
                                        : section == sections[1]
                                            ? 'center'
                                            : 'south');
                                if (widget.edit && widget.province != null) {
                                  updateProvince(data);
                                } else {
                                  addNewProvince(data);
                                }
                                setState(() {
                                  warning = "";
                                });
                              }
                            },
                            child: const Text('ບັນທືກ')),
                      )
                    ],
                  ))),
        );
      },
    );
  }

  void addNewProvince(ProvinceModel data) async {
    myProgress(context, null);
    await ProvinceModel.postProvince(data: data).then((add) {
      if (add.code == 201) {
        provinceController.clear();
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ບັນທືກ',
                content: 'ບັນທືກຂໍ້ມູນສຳເລັດແລ້ວ')
            .then((value) => context.read<ProvinceBloc>().add(FetchProvince()));
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

  void updateProvince(ProvinceModel data) async {
    myProgress(context, null);
    await ProvinceModel.putProvince(data: data).then((update) {
      if (update.code == 200) {
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ແກ້ໄຂ',
                content: 'ແກ້ໄຂຂໍ້ມູນສຳເລັດແລ້ວ')
            .then((value) {
          context.read<ProvinceBloc>().add(FetchProvince());
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
