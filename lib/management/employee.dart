import 'package:clinic/provider/bloc/user_bloc.dart';
import 'package:clinic/provider/event/user_event.dart';
import 'package:clinic/provider/state/user_state.dart';
import 'package:clinic/style/color.dart';
import 'package:clinic/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context.read<UserBloc>().add(FetchUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: const Text('ຂໍ້ມູນພະນັກງານ'), actions: [
          IconButton(
              icon: const Icon(Icons.add_circle_outline), onPressed: () {})
        ]),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInitialState) {
                  _onRefresh();
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is UserLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is UserLoadCompleteState) {
                  if (state.users.isEmpty) return _isStateEmty();
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (_, index) => ListTile(
                              title: Text(
                                  '${state.users[index].profile.firstname} ${state.users[index].profile.lastname}'),
                              subtitle: Text(state.users[index].phone),
                            )),
                  );
                }
                if (state is UserErrorState) {
                  return _isStateEmty(message: state.error.toString());
                } else {
                  return _isStateEmty();
                }
              },
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

  Widget _buildMenu() {
    return PopupMenuButton(
        icon: const Icon(Icons.more_vert_rounded, color: primaryColor),
        itemBuilder: (context) => [
              PopupMenuItem(
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
            ]);
  }
}
