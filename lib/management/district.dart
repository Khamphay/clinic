import 'package:clinic/alert/progress.dart';
import 'package:clinic/controller/custombutton.dart';
import 'package:clinic/management/form/district_form.dart';
import 'package:clinic/management/form/provice_form.dart';
import 'package:clinic/model/district_model.dart';
import 'package:clinic/provider/bloc/district_bloc.dart';
import 'package:clinic/provider/event/district_event.dart';
import 'package:clinic/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../provider/state/district_state.dart';

class DistrictPage extends StatefulWidget {
  const DistrictPage({Key? key, required this.provinceId}) : super(key: key);
  final int provinceId;

  @override
  State<DistrictPage> createState() => _DistrictPageState();
}

class _DistrictPageState extends State<DistrictPage> {
  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context
        .read<DistrictBloc>()
        .add(FetchDistrict(provinceId: widget.provinceId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(title: const Text('ຂໍ້ມູນເມືອງ'), actions: [
        IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              _editerDialog(null, false);
            })
      ]),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<DistrictBloc, DistrictState>(
            builder: (context, state) {
              if (state is DistrictInitialState) {
                _onRefresh();
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DistrictLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DistrictLoadCompleteState) {
                if (state.districts.isEmpty) return _isStateEmty();

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                      itemCount: state.districts.length,
                      itemBuilder: (_, index) => ListTile(
                            title: Text(state.districts[index].name),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              EditButton(
                                  onPressed: () => _editerDialog(
                                      state.districts[index], true)),
                              const SizedBox(width: 10),
                              DeleteButton(onPressed: () {
                                showQuestionDialog(
                                        context: context,
                                        title: 'ລຶບ',
                                        content: "ຕ້ອງການລຶບຂໍ້ມູນແມ່ນບໍ?")
                                    .then((value) {
                                  if (value != null && value) {
                                    state.districts[index].isDelete = 'yes';
                                    onDelete(state.districts[index]);
                                  }
                                });
                              })
                            ]),
                          )),
                );
              }

              if (state is DistrictErrorState) {
                return _isStateEmty(message: state.error);
              } else {
                return _isStateEmty();
              }
            },
          )),
    );
  }

  Widget _isStateEmty({String? message}) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () => _onRefresh(),
            icon:
                const Icon(Icons.sync_rounded, size: 30, color: primaryColor)),
        const SizedBox(
          width: 10,
        ),
        Text(message ?? 'ບໍ່ມີຂໍ້ມູນ'),
      ],
    ));
  }

  Future _editerDialog(DistrictModel? district, bool edit) {
    return showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (_contex, state) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(0),
              content: DistrictFormEditor(
                  edit: edit,
                  provinceId: widget.provinceId,
                  district: district),
            );
          });
        });
  }

  // void onEdit(DistrictModel data) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => DistrictFormEditor(
  //               edit: true, district: data, provinceId: widget.provinceId)));
  // }

  void onDelete(DistrictModel data) async {
    myProgress(context, null);
    await DistrictModel.deleteDistrict(data: data).then((update) {
      if (update.code == 200) {
        Navigator.pop(context);
        showCompletedDialog(
                context: context, title: 'ລຶບ', content: 'ລຶບຂໍ້ມູນສຳເລັດແລ້ວ')
            .then((value) => _onRefresh());
      } else {
        Navigator.pop(context);
        showFailDialog(
            context: context,
            title: 'ລຶບ',
            content: update.error ?? 'ລຶບຂໍ້ມູນບໍ່ສຳເລັດ');
      }
    }).catchError((onError) {
      Navigator.pop(context);
      showFailDialog(
          context: context, title: 'ລຶບ', content: onError.toString());
    });
  }
}
