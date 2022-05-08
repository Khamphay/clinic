import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/model/promotion_model.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PromotionDetailPage extends StatefulWidget {
  const PromotionDetailPage({Key? key, required this.promotion})
      : super(key: key);
  final PromotionModel promotion;

  @override
  State<PromotionDetailPage> createState() => _PromotionDetailPageState();
}

class _PromotionDetailPageState extends State<PromotionDetailPage> {
  late PromotionModel promotion;
  @override
  void initState() {
    promotion = widget.promotion;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: Text(promotion.name)),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: 200,
              width: size.width,
              color: Colors.white,
              child: (promotion.image!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: urlImg + '/${promotion.image}',
                      errorWidget: (context, url, error) => SvgPicture.asset(
                          'assets/images/no_promotion.svg',
                          fit: BoxFit.contain))
                  : SvgPicture.asset('assets/images/no_promotion.svg',
                      fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ຫົວຂໍ້: ${promotion.name}',
                      style: Theme.of(context).textTheme.headline1),
                  const Divider(color: primaryColor),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: RichText(
                          text: TextSpan(
                              text: 'ຫຼຸດສູງສຸດ: ',
                              children: [
                                TextSpan(
                                    text: '${fm.format(promotion.discount)}%',
                                    style: normalText),
                              ],
                              style: bodyText2Bold))),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: RichText(
                          text: TextSpan(
                              text: 'ເລີ່ມຕັ້ງແຕ່ວັນທີ: ',
                              children: [
                                TextSpan(
                                    text: fmdate.format(
                                        DateTime.parse(promotion.start)),
                                    style: normalText),
                              ],
                              style: bodyText2Bold))),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: RichText(
                          text: TextSpan(
                              text: 'ສິ້ນສຸດວັນທີ: ',
                              children: [
                                TextSpan(
                                    text: fmdate
                                        .format(DateTime.parse(promotion.end)),
                                    style: normalText),
                              ],
                              style: bodyText2Bold))),
                  const Divider(color: primaryColor),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                        text: TextSpan(
                            text: '\t\t\tລາຍລະອຽດ: ',
                            children: [
                              TextSpan(
                                  text: promotion.detail, style: normalText)
                            ],
                            style: bodyText2Bold)),
                  )
                ],
              ),
            ),
          ]),
        ));
  }
}
