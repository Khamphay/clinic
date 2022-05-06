import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/controller/customcontainer.dart';
import 'package:clinic/model/district_model.dart';
import 'package:clinic/provider/bloc/district_bloc.dart';
import 'package:clinic/provider/bloc/province_bloc.dart';
import 'package:clinic/provider/event/district_event.dart';
import 'package:clinic/provider/event/province_event.dart';
import 'package:clinic/provider/state/province_state.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/size.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DistrictFormEditor extends StatefulWidget {
  const DistrictFormEditor(
      {Key? key, required this.edit, this.district, required this.provinceId})
      : super(key: key);
  final bool edit;
  final DistrictModel? district;
  final int provinceId;

  @override
  State<DistrictFormEditor> createState() => _DistrictFormEditorState();
}

class _DistrictFormEditorState extends State<DistrictFormEditor> {
  final districtController = TextEditingController();
  String province = '', warning = '';

  @override
  void initState() {
    if (widget.edit && widget.district != null) {
      districtController.text = widget.district!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProvinceBloc, ProvinceState>(
      builder: (context, state) {
        return Component(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(widget.edit ? 'ແກ້ໄຂເມືອງ' : 'ເພີ່ມເມືອງ',
                    style: bodyText2Bold)),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
              child: Divider(color: primaryColor, height: 2),
            ),
            CustomContainer(
                errorMsg: warning,
                title: const Text("ຊື່ເມືອງ"),
                padding: const EdgeInsets.only(left: 10),
                borderRadius: BorderRadius.circular(radius),
                child: TextFormField(
                  controller: districtController,
                  decoration: const InputDecoration(border: InputBorder.none),
                )),
            ButtonBar(mainAxisSize: MainAxisSize.min, children: [
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(105, 48)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ຍົກເລີກ')),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(105, 48)),
                  onPressed: () {
                    if (districtController.text.isEmpty) {
                      warning = "ກະລຸນາປ້ອນຂໍ້ມູນເມືອງ";
                      setState(() {});
                    } else {
                      final data = DistrictModel(
                          id: widget.district != null
                              ? widget.district!.id
                              : null,
                          provinceId: widget.provinceId,
                          name: districtController.text);
                      if (widget.edit && widget.district != null) {
                        updateDistrict(data);
                      } else {
                        addNewDistrict(data);
                      }
                      setState(() {
                        warning = "";
                      });
                    }
                  },
                  child: const Text('ບັນທືກ'))
            ])
          ],
        ));
      },
    );
  }

  void addNewDistrict(DistrictModel data) async {
    myProgress(context, null);
    await DistrictModel.postDistrict(data: data).then((add) {
      if (add.code == 201) {
        districtController.clear();
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ບັນທືກ',
                content: 'ບັນທືກຂໍ້ມູນສຳເລັດແລ້ວ')
            .then((value) {
          context
              .read<DistrictBloc>()
              .add(FetchDistrict(provinceId: widget.provinceId));
          Navigator.pop(context);
        });
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

  void updateDistrict(DistrictModel data) async {
    myProgress(context, null);
    await DistrictModel.putDistrict(data: data).then((update) {
      if (update.code == 200) {
        Navigator.pop(context);
        showCompletedDialog(
                context: context,
                title: 'ແກ້ໄຂ',
                content: 'ແກ້ໄຂຂໍ້ມູນສຳເລັດແລ້ວ')
            .then((value) {
          context
              .read<DistrictBloc>()
              .add(FetchDistrict(provinceId: widget.provinceId));
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
