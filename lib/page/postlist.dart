import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/model/post_model.dart';
import 'package:clinic/notification/socket/socket_controller.dart';
import 'package:clinic/page/postdetail_page.dart';
import 'package:clinic/provider/bloc/post_bloc.dart';
import 'package:clinic/provider/event/post_event.dart';
import 'package:clinic/provider/state/post_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context.read<PostBloc>().add(FetchPost());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostInitialState) {
                _onRefresh();
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PostLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PostLoadCompleteState) {
                if (state.posts.isEmpty) return _isStateEmty();
                return ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (_, index) {
                      return _buildCard(state.posts[index]);
                    });
              }

              if (state is PostErrorState) {
                return _isStateEmty();
              } else {
                return _isStateEmty();
              }
            },
          ),
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
        Text(message ?? 'ບໍ່ມີຂ່າວ'),
      ],
    ));}

  Widget _buildCard(PostModel data) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => PostDetailPage(post: data))),
      child: Component(
          height: 210,
          borderRadius: BorderRadius.circular(5),
          child: GridTile(
            child: (data.image!.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: urlImg + '/${data.image}',
                    errorWidget: (context, url, error) => SvgPicture.asset(
                        'assets/images/no_promotion.svg',
                        fit: BoxFit.fitWidth))
                : SvgPicture.asset('assets/images/no_promotion.svg',
                    fit: BoxFit.fill),
            footer: Container(
              height: 100,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ຫົວຂໍ້ຂ່າວ: ${data.name}',
                          style: bodyText2Bold,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const Divider(color: primaryColor, height: 2),
                      Text('\t\t\t${data.detail}',
                          style: normalText,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis)
                    ]),
              ),
            ),
          )),
    );
  }
}
