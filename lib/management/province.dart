import 'package:clinic/alert/progress.dart';
import 'package:clinic/controller/custombutton.dart';
import 'package:clinic/management/form/provice_form.dart';
import 'package:clinic/model/province_model.dart';
import 'package:clinic/provider/bloc/province_bloc.dart';
import 'package:clinic/provider/event/province_event.dart';
import 'package:clinic/provider/state/province_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProvincePage extends StatefulWidget {
  const ProvincePage({Key? key}) : super(key: key);

  @override
  State<ProvincePage> createState() => _ProvincePageState();
}

class _ProvincePageState extends State<ProvincePage> {
  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context.read<ProvinceBloc>().add(FetchProvince());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(title: const Text('ຂໍ້ມູນແຂວງ'), actions: [
        IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProvinceFormEditor(
                          title: 'ເພີ່ມ', edit: false)));
            })
      ]),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<ProvinceBloc, ProvinceState>(
            builder: (context, state) {
              if (state is ProvinceInitialState) {
                _onRefresh();
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProvinceLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProvinceLoadCompleteState) {
                if (state.provinces.isEmpty) return _isStateEmty();

                return ListView.builder(
                    itemCount: state.provinces.length,
                    itemBuilder: (_, index) => ListTile(
                          title: Text(state.provinces[index].name),
                          subtitle:
                              Text(state.provinces[index].section == 'north'
                                  ? sections[0]
                                  : state.provinces[index].section == 'center'
                                      ? sections[1]
                                      : sections[2]),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            EditButton(
                                onPressed: () =>
                                    onEdit(state.provinces[index])),
                            const SizedBox(width: 10),
                            DeleteButton(onPressed: () {
                              showQuestionDialog(
                                      context: context,
                                      title: 'ລຶບ',
                                      content: "ຕ້ອງການລຶບຂໍ້ມູນແມ່ນບໍ?")
                                  .then((value) {
                                if (value != null && value) {
                                  state.provinces[index].isDelete = 'yes';
                                  onDelete(state.provinces[index]);
                                }
                              });
                            })
                          ]),
                        ));
              }

              if (state is ProvinceErrorState) {
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

  void onEdit(ProvinceModel data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProvinceFormEditor(
                title: 'ແກ້ໄຂ', edit: true, province: data)));
  }

  void onDelete(ProvinceModel data) async {
    myProgress(context, null);
    await ProvinceModel.deleteProvince(data: data).then((update) {
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
