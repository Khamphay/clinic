import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/controller/custombutton.dart';
import 'package:clinic/management/form/promotion_form.dart';
import 'package:clinic/model/promotion_model.dart';
import 'package:clinic/provider/bloc/promotion_bloc.dart';
import 'package:clinic/provider/state/promotion_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../provider/event/promotion_event.dart';

class PromotionPage extends StatefulWidget {
  const PromotionPage({Key? key}) : super(key: key);

  @override
  State<PromotionPage> createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context.read<PromotionBloc>().add(FetchPromotion());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("ຂໍ້ມູນໂປຣໂມຊັນ"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PromotionFormEditor(title: 'ເພີ່ມ', edit: false),
                  )),
              icon: const Icon(Icons.add_circle_outline))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<PromotionBloc, PromotionState>(
            builder: (context, state) {
              if (state is PromotionInitialState) {
                _onRefresh();
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PromotionLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PromotionLoadCompleteState) {
                if (state.promotions.isEmpty) return _isStateEmty();
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                      itemCount: state.promotions.length,
                      itemBuilder: (_, index) {
                        return buildCard(state.promotions[index]);
                      }),
                );
              }

              if (state is PromotionErrorState) {
                return _isStateEmty(message: state.error);
              } else {
                return _isStateEmty();
              }
            },
          )),
    );
  }

  Widget buildCard(PromotionModel promotion) {
    return Component(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: promotion.image!.isNotEmpty
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: urlImg + "/${promotion.image}",
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(
                              Icons.image_not_supported_outlined,
                              size: 70),
                        )
                      : const Icon(Icons.image_not_supported_outlined,
                          size: 70)),
            ),
            const SizedBox(width: 9),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ຫົວຂໍ້ສ່ວນຫຼຸດ: ${promotion.name}",
                      style: bodyText2Bold),
                  Text("ເປີເຊັນສ່ວນຫຼຸດ: ${promotion.discount}%"),
                  Text(
                      "ເລີ່ມວັນທີ: ${fmdate.format(DateTime.parse(promotion.start))}"),
                  Text(
                      'ວັນທີ່ສິ້ນສຸດ: ${fmdate.format(DateTime.parse(promotion.end))}'),
                ],
              ),
            ),
            // const Spacer(),
            Column(
              children: [
                EditButton(onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PromotionFormEditor(
                            title: 'ແກ້ໄຂ', edit: true, promotion: promotion),
                      ));
                }),
                const SizedBox(height: 15),
                DeleteButton(onPressed: () {
                  showQuestionDialog(
                          context: context,
                          title: 'ລຶບ',
                          content: "ຕ້ອງການລຶບຂໍ້ມູນແມ່ນບໍ?")
                      .then((value) {
                    if (value != null && value) {
                      onDelete(promotion.id ?? 0);
                    }
                  });
                })
              ],
            ),
          ],
        ),
      ),
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

  void onDelete(int id) async {
    myProgress(context, null);
    await PromotionModel.detelePromotion(id: id).then((delete) {
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
