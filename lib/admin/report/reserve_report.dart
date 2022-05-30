import 'package:clinic/admin/management/reserve_detail.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/model/reserve_model.dart';
import 'package:clinic/provider/bloc/reserve_bloc.dart';
import 'package:clinic/provider/event/reserve_event.dart';
import 'package:clinic/provider/state/reserve_state.dart';
import 'package:clinic/source/source.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReserveHistoryPage extends StatefulWidget {
  const ReserveHistoryPage({Key? key}) : super(key: key);

  @override
  State<ReserveHistoryPage> createState() => _ReserveHistoryPageState();
}

class _ReserveHistoryPageState extends State<ReserveHistoryPage> {
  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context.read<ReserveBloc>().add(FetchAllReserve(status: 'complete'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: const Text("ການນັດໝາຍ")),
        body: SizedBox(
            width: size.width,
            height: size.height,
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: BlocBuilder<ReserveBloc, ReserveState>(
                builder: (context, state) {
                  if (state is ReserveInitialState) {
                    _onRefresh();
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ReserveLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ReserveLoadCompleteState) {
                    return ListView.builder(
                        itemCount: state.reserves.length,
                        itemBuilder: (_, index) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ReserveDetailPage(
                                              data: state.reserves[index])));
                                },
                                leading: CircleAvatar(
                                    radius: 20, child: Text('${index + 1}')),
                                title: Text(
                                    '${state.reserves[index].user!.profile.firstname} ${state.reserves[index].user!.profile.lastname}',
                                    style: title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'ເບີໂທ: ${state.reserves[index].user!.phone} \nວັນທີ: ${fmdate.format(DateTime.parse(state.reserves[index].startDate))}'),
                                  ],
                                ),
                              ),
                              const Divider(color: primaryColor, height: 2)
                            ],
                          );
                        });
                  }

                  if (state is ReserveErrorState) {
                    return _isStateEmty(message: state.error);
                  } else {
                    return _isStateEmty();
                  }
                },
              ),
            )));
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
}
