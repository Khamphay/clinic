import 'package:clinic/admin/management/form/employee_form.dart';
import 'package:clinic/alert/progress.dart';
import 'package:clinic/model/user_model.dart';
import 'package:clinic/provider/bloc/user_bloc.dart';
import 'package:clinic/provider/event/user_event.dart';
import 'package:clinic/provider/state/user_state.dart';
import 'package:clinic/source/source.dart';
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
    context.read<UserBloc>().add(FetchEmployee());
  }

  @override
  void initState() {
    _onRefresh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: const Text('ຂໍ້ມູນທ່ານໝໍ'), actions: [
          IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EmployeeFrom(edit: false)));
              })
        ]),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInitialState) {
                  _onRefresh();
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is EmployeeLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is EmployeeLoadCompleteState) {
                  if (state.employees.isEmpty) return _isStateEmty();
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                        itemCount: state.employees.length,
                        itemBuilder: (_, index) => ListTile(
                              leading: state.employees[index].profile.image!
                                      .isNotEmpty
                                  ? CircleAvatar(
                                      maxRadius: 30,
                                      backgroundImage: NetworkImage(
                                          "$urlImg/${state.employees[index].profile.image!}",
                                          scale: 100))
                                  : const Icon(Icons.account_circle_outlined,
                                      size: 40, color: primaryColor),
                              title: Text(
                                  '${state.employees[index].profile.firstname} ${state.employees[index].profile.lastname}'),
                              subtitle: Text(state.employees[index].phone),
                              trailing: _buildMenu(state.employees[index]),
                            )),
                  );
                }
                if (state is EmployeeErrorState) {
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

  Widget _buildMenu(UserModel user) {
    return PopupMenuButton(
        icon: const Icon(Icons.more_vert_rounded, color: primaryColor),
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
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
                  value: 2,
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
            ],
        onSelected: (value) async {
          if (value == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EmployeeFrom(edit: true, user: user)));
          } else if (value == 2) {
            showQuestionDialog(
                    context: context,
                    title: 'ລຶບຂໍ້ມູນ',
                    content: 'ຕ້ອງການລຶບຂໍ້ມູນແມ່ນບໍ?')
                .then((value) async {
              if (value != null && value == true) {
                await UserModel.deleteUser(user: user).then((data) {
                  if (data.code == 200) {
                    showCompletedDialog(
                            context: context,
                            title: 'ລຶບຂໍ້ມູນ',
                            content: "ລຶບຂໍ້ມູນສຳເລັດແລ້ວ")
                        .then((value) =>
                            context.read<UserBloc>().add(FetchEmployee()));
                  }
                });
              }
            });
          }
        });
  }
}
