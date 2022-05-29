import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/admin/management/form/reserve_form.dart';
import 'package:clinic/component/component.dart';
import 'package:clinic/model/tooth_model.dart';
import 'package:clinic/page/zoom_image.dart';
import 'package:clinic/provider/bloc/tooth_bloc.dart';
import 'package:clinic/provider/event/tooth_event.dart';
import 'package:clinic/provider/state/tooth_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ToothListPage extends StatefulWidget {
  const ToothListPage({Key? key}) : super(key: key);

  @override
  State<ToothListPage> createState() => _ToothListPageState();
}

class _ToothListPageState extends State<ToothListPage> {
  double radius = 10;
  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context.read<ToothBloc>().add(FetchTooth());
  }

  @override
  void didChangeDependencies() {
    _onRefresh();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("ລາຍການແຂ້ວ"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: BlocBuilder<ToothBloc, ToothState>(
              builder: (context, state) {
                if (state is ToothInitialState) {
                  _onRefresh();
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ToothLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ToothLoadCompleteState) {
                  if (state.tooths.isEmpty) return _onStateEmty();
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: state.tooths.length,
                      itemBuilder: (_, index) {
                        return buildCard(state.tooths[index]);
                      });
                } else {
                  return _onStateEmty();
                }
              },
            ),
          )),
    );
  }

  Widget buildCard(ToothModel tooth) {
    return Component(
        child: InkWell(
      borderRadius: BorderRadius.circular(radius),
      onLongPress: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>
                ZoomImagePage(title: tooth.name, imageSource: tooth.image!)));
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ReserveFormPage(edit: false, tooth: tooth)));
      },
      child: GridTile(
        child: tooth.image!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: urlImg + "/${tooth.image}",
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => SvgPicture.asset(
                        'assets/images/no_promotion.svg',
                        fit: BoxFit.fill)),
              )
            : SvgPicture.asset('assets/images/no_promotion.svg',
                fit: BoxFit.contain),
        footer: Container(
          height: 70,
          padding: const EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tooth.name,
                  style: subTitle,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              Text('ລາຄາ: ${fm.format(tooth.startPrice)} ກິບ', style: text),
            ],
          ),
        ),
      ),
    ));
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
          const Text('ບໍ່ມີຂໍ້ມູນລາຍການແຂ້ວ', style: bodyText2Bold)
        ],
      ),
    );
  }
}
