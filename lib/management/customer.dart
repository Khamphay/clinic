import 'package:clinic/management/form/user_detail.dart';
import 'package:clinic/provider/bloc/user_bloc.dart';
import 'package:clinic/provider/event/user_event.dart';
import 'package:clinic/provider/state/user_state.dart';
import 'package:clinic/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  Future<void> _onRefresh() async {
    Future.delayed(const Duration(seconds: 0));
    context.read<UserBloc>().add(FetchUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: const Text('ຂໍ້ມູນລູກຄ້າ')),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (_context, state) {
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
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => UserDetail(
                                          user: state.users[index]))),
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
}
