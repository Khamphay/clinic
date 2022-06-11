import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clinic/admin/management/customer.dart';
import 'package:clinic/admin/management/employee.dart';
import 'package:clinic/admin/management/post.dart';
import 'package:clinic/admin/management/promotion.dart';
import 'package:clinic/admin/management/province.dart';
import 'package:clinic/admin/management/reserve.dart';
import 'package:clinic/admin/management/tooth.dart';
import 'package:clinic/admin/report/reserve_report.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/model/promotion_model.dart';
import 'package:clinic/page/customer_reserve.dart';
import 'package:clinic/page/promotiondetail_page.dart';
import 'package:clinic/page/reserve_history.dart';
import 'package:clinic/page/toothlist_page.dart';
import 'package:clinic/provider/bloc/promotion_bloc.dart';
import 'package:clinic/provider/notification_provider.dart';
import 'package:clinic/provider/state/promotion_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _curIndex = 0;
  final carousContext = CarouselController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<NotificationManager>(builder: (context, value, child) {
      return BlocBuilder<PromotionBloc, PromotionState>(
        builder: (_, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(children: [
                Container(
                    height: 200,
                    width: size.width,
                    color: Colors.white60,
                    child: GridTile(
                      child: Builder(builder: (_) {
                        if (state is CustomerPromotionLoadCompleteState) {
                          return _buildSlider(state.promotions);
                        } else if (state is PromotionLoadCompleteState) {
                          return _buildSlider(state.promotions
                              .where((item) => DateTime.now()
                                  .isBefore(DateTime.parse(item.end)))
                              .toList());
                        } else if (state is PromotionLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return const Center(
                              child:
                                  Text('ບໍ່ມີໂປຣໂມຊັນ', style: bodyText2Bold));
                        }
                      }),
                      footer: Stack(children: [
                        Container(
                            height: 90,
                            color: primaryColor.withOpacity(0.2),
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 2, color: primaryColor))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          context
                                              .read<NotificationManager>()
                                              .promoTitle,
                                          style: title,
                                          softWrap: true,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      const Divider(
                                          color: primaryColor, height: 2),
                                      Text(
                                          context
                                              .read<NotificationManager>()
                                              .promoDate,
                                          style: text),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 4),
                                    child: Text(
                                        context
                                                    .read<NotificationManager>()
                                                    .promoDiscount >
                                                0
                                            ? 'ຫຼຸດສູງສຸດ: ${context.read<NotificationManager>().promoDiscount}%'
                                            : '',
                                        style: text),
                                  )),
                            ])),
                        Positioned(
                          left: size.width / 2.5,
                          bottom: 0,
                          child: Builder(builder: (context) {
                            if (state is CustomerPromotionLoadCompleteState) {
                              return _buildSliderDot(state.promotions);
                            } else if (state is PromotionLoadCompleteState) {
                              return _buildSliderDot(state.promotions
                                  .where((item) => DateTime.now()
                                      .isBefore(DateTime.parse(item.end)))
                                  .toList());
                            } else {
                              return const Center();
                            }
                          }),
                        ),
                      ]),
                    )),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          isAdmin||isEmployee ? _buildAdminMenus() : _buildMemberMenus()),
                )
              ]),
            ),
          );
        },
      );
    });
  }

  Widget _buildSlider(List<PromotionModel> promotions) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    PromotionDetailPage(promotion: promotions[_curIndex])));
      },
      child: CarouselSlider(
          carouselController: carousContext,
          options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 10),
              autoPlayAnimationDuration: const Duration(seconds: 2),
              onPageChanged: (index, reason) {
                setState(() {
                  _curIndex = index;
                  context
                      .read<NotificationManager>()
                      .setpromoTitle(title: promotions[_curIndex].name);
                  context.read<NotificationManager>().setpromoDate(
                      date:
                          'ເລີ່ມວັນທີ: ${fmdate.format(DateTime.parse(promotions[_curIndex].start))} \nຫາວັນທີ: ${fmdate.format(DateTime.parse(promotions[_curIndex].end))}');
                  context.read<NotificationManager>().setpromoDiscount(
                      discount: promotions[_curIndex].discount);
                });
              }),
          items: promotions
              .map((e) => (e.image!.isEmpty)
                  ? SvgPicture.asset(
                      'assets/images/no_promotion.svg',
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: urlImg + '/${e.image}',
                      fit: BoxFit.fill,
                    ))
              .toList()),
    );
  }

  Widget _buildSliderDot(List<PromotionModel> promotions) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: promotions.asMap().entries.map((e) {
          return GestureDetector(
            onTap: () => carousContext.animateToPage(e.key),
            child: Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      primaryColor.withOpacity(_curIndex == e.key ? 0.9 : 0.4)),
            ),
          );
        }).toList());
  }

  Widget _buildAdminMenus() {
    return GridView(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: [
          Component(
              child: InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProvincePage())),
                  focusColor: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.edit_note_rounded, size: 40),
                        Center(child: Text("ຂໍ້ມູນທີ່ຢູ່", style: bodyText2Bold))
                      ]))),
          Component(
              child: InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ToothPage())),
                  focusColor: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_reaction_outlined, size: 40),
                        Center(child: Text("ລາຄາແຂ້ວ", style: bodyText2Bold))
                      ]))),
          Component(
              child: InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PromotionPage())),
                  focusColor: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.card_giftcard_rounded, size: 40),
                        Center(child: Text("ໂປຣໂມຊັນ", style: bodyText2Bold))
                      ]))),
          Component(
              child: InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PostPage())),
                  focusColor: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.newspaper_rounded, size: 40),
                        Center(child: Text("ຂ່າວສານຄວາມຮູ້", style: bodyText2Bold))
                      ]))),
          Component(
              child: InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CustomerPage())),
                  focusColor: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.account_circle_outlined, size: 40),
                        Center(child: Text("ຂໍ້ມູນລູກຄ້າ", style: bodyText2Bold))
                      ]))),
          Component(
              child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ReservePage()));
                  },
                  focusColor: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.calendar_month_rounded, size: 40),
                        Center(
                            child: Text("ນັດໝາຍລູກຄ້າ", style: bodyText2Bold))
                      ]))),
          Component(
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ReserveHistoryPage()));
                  },
                  focusColor: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.list_alt_rounded, size: 40),
                        Text("ປະຫວັດການບໍລິການ",
                            textAlign: TextAlign.center, style: bodyText2Bold)
                      ]))),
                          isAdmin
              ? Component(
                  child: InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const EmployeePage())),
                      focusColor: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.person, size: 40),
                            Center(
                                child:
                                    Text("ຂໍ້ມູນທ່ານໝໍ", style: bodyText2Bold))
                          ])))
              : const Center(),
        ]);
  }

  Widget _buildMemberMenus() {
    return GridView(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: [
          Component(
              child: InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ToothListPage())),
                  focusColor: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_reaction_outlined, size: 40),
                        Center(child: Text("ລາຍການລາຄາແຂ້ວ", style: bodyText2Bold))
                      ]))),
          Component(
              child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CustomerReservePage())),
                  focusColor: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.quick_contacts_dialer_rounded, size: 40),
                        Center(child: Text("ຈອງຄິວ", style: bodyText2Bold))
                      ]))),
          // Component(
          //     child: InkWell(
          //         onTap: () => Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (_) => const PromotionListPage())),
          //         focusColor: primaryColor,
          //         borderRadius: BorderRadius.circular(10),
          //         child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: const [
          //               Icon(Icons.card_giftcard_rounded, size: 40),
          //               Center(child: Text("ໂປຣໂມຊັນ", style: bodyText2Bold))
          //             ]))),
          Component(
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const CustomerHistoryReservePage()));
                  },
                  focusColor: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.list_alt_rounded, size: 40),
                        Text("ປະຫວັດການບໍລິການ",
                            textAlign: TextAlign.center, style: bodyText2Bold)
                      ]))),
        ]);
  }
}
