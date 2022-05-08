import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/model/post_model.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key, required this.post}) : super(key: key);
  final PostModel post;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late PostModel post;
  @override
  void initState() {
    post = widget.post;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: Text(post.name)),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: 200,
              width: size.width,
              color: Colors.white,
              child: (post.image!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: urlImg + '/${post.image}',
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
                  Text('ຫົວຂໍ້ຂ່າວ: ${post.name}',
                      style: Theme.of(context).textTheme.headline1),
                  const Divider(color: primaryColor),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                        text: TextSpan(
                            text: '\t\t\tລາຍລະອຽດຂ່າວ: ',
                            children: [
                              TextSpan(text: post.detail, style: normalText)
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
