import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/model/promotion_model.dart';
import 'package:clinic/page/Promotiondetail_page.dart';
import 'package:clinic/provider/bloc/promotion_bloc.dart';
import 'package:clinic/provider/event/promotion_event.dart';
import 'package:clinic/provider/state/promotion_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PromotionListPage extends StatefulWidget {
  const PromotionListPage({Key? key}) : super(key: key);

  @override
  State<PromotionListPage> createState() => _PromotionListPageState();
}

class _PromotionListPageState extends State<PromotionListPage> {
  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context.read<PromotionBloc>().add(FetchPromotion());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // appBar: AppBar(
      //   title: const Text('ໂປຣໂມຊັນ'),
      // ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
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
                if (state.promotions.isEmpty) return _onStateEmty();
                return ListView.builder(
                    itemCount: state.promotions.length,
                    itemBuilder: (_, index) {
                      return _buildCard(state.promotions[index]);
                    });
              }

              if (state is PromotionErrorState) {
                return _onStateEmty();
              } else {
                return _onStateEmty();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _onStateEmty() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: SvgPicture.asset('assets/images/not_found.svg'),
          ),
          const Text('ບໍ່ມີໂປຣໂມຊັນ', style: bodyText2Bold)
        ],
      ),
    );
  }

  Widget _buildCard(PromotionModel data) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PromotionDetailPage(promotion: data))),
      child: Component(
          height: 160,
          borderRadius: BorderRadius.circular(5),
          margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Row(
            children: [
              Flexible(
                child: (data.image!.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: urlImg + '/${data.image}',
                        errorWidget: (context, url, error) => SvgPicture.asset(
                            'assets/images/no_promotion.svg',
                            fit: BoxFit.fitWidth))
                    : SvgPicture.asset('assets/images/no_promotion.svg',
                        fit: BoxFit.fill),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ຫົວຂໍ້: ${data.name}',
                              style: bodyText2Bold,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          const Divider(color: primaryColor, height: 2),
                          Text('\t\t\t${data.detail}',
                              style: normalText,
                              softWrap: true,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis),
                          Row(
                            // mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text: "ສິ້ນສຸດວັນທີ: ",
                                      children: [
                                        TextSpan(
                                            text: fmdate.format(
                                                DateTime.parse(data.end)),
                                            style: normalText)
                                      ],
                                      style: bodyText2Bold)),
                            ],
                          )
                        ]),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
