import 'package:clinic/alert/progress.dart';
import 'package:clinic/management/district.dart';
import 'package:clinic/management/form/provice_form.dart';
import 'package:clinic/model/province_model.dart';
import 'package:clinic/provider/bloc/province_bloc.dart';
import 'package:clinic/provider/event/province_event.dart';
import 'package:clinic/provider/state/province_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
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

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                      itemCount: state.provinces.length,
                      itemBuilder: (_, index) => ListTile(
                          title: Text(state.provinces[index].name),
                          subtitle:
                              Text(state.provinces[index].section == 'north'
                                  ? sections[0]
                                  : state.provinces[index].section == 'center'
                                      ? sections[1]
                                      : sections[2]),
                          trailing: _buildMenu(state.provinces[index]))),
                );
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

  Widget _buildMenu(ProvinceModel province) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert_rounded, color: primaryColor),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.add_box_outlined, color: primaryColor),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("ເພີ່ມເມືອງ"),
                )
              ],
            )),
        PopupMenuItem(
            value: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.edit, color: primaryColor),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("ແກ້ໄຂ"),
                )
              ],
            )),
        PopupMenuItem(
            value: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.delete_forever_rounded, color: errorColor),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("ລຶບ", style: errorText),
                )
              ],
            )),
      ],
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DistrictPage(provinceId: province.id ?? 0)));
        } else if (value == 2) {
          onEdit(province);
        } else if (value == 3) {
          showQuestionDialog(
                  context: context,
                  title: 'ລຶບ',
                  content: "ຕ້ອງການລຶບຂໍ້ມູນແມ່ນບໍ?")
              .then((value) {
            if (value != null && value) {
              province.isDelete = 'yes';
              onDelete(province);
            }
          });
        }
      },
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
    await ProvinceModel.deleteProvince(data: data).then((delete) {
      if (delete.code == 200) {
        Navigator.pop(context);
        showCompletedDialog(
                context: context, title: 'ລຶບ', content: 'ລຶບຂໍ້ມູນສຳເລັດແລ້ວ')
            .then((value) => _onRefresh());
      } else {
        Navigator.pop(context);
        showFailDialog(
            context: context,
            title: 'ລຶບ',
            content: delete.error ?? 'ລຶບຂໍ້ມູນບໍ່ສຳເລັດ');
      }
    }).catchError((onError) {
      Navigator.pop(context);
      showFailDialog(
          context: context, title: 'ລຶບ', content: onError.toString());
    });
  }
}
