import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/admin/management/form/post_form.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/controller/custombutton.dart';
import 'package:clinic/model/post_model.dart';
import 'package:clinic/provider/bloc/post_bloc.dart';
import 'package:clinic/provider/event/post_event.dart';
import 'package:clinic/provider/state/post_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context.read<PostBloc>().add(FetchPost());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("ຂໍ້ມູນຂ່າວສານ"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PostFormEditor(title: 'ເພີ່ມ', edit: false),
                  )),
              icon: const Icon(Icons.add_circle_outline))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
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
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (_, index) {
                        return buildCard(state.posts[index]);
                      }),
                );
              }

              if (state is PostErrorState) {
                return _isStateEmty(message: state.error);
              } else {
                return _isStateEmty();
              }
            },
          )),
    );
  }

  Widget buildCard(PostModel post) {
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
                  child: post.image!.isNotEmpty
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: urlImg + "/${post.image}",
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
                  Text("ຫົວຂໍ້ຂ່າວ: ${post.name}", style: bodyText2Bold),
                  Text('ລາຍລະອຽດຂ່າວ: ${post.detail}',
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
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
                        builder: (_) => PostFormEditor(
                            title: 'ແກ້ໄຂ', edit: true, post: post),
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
                      onDelete(post.id ?? 0);
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
    await PostModel.detelePost(id: id).then((delete) {
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
