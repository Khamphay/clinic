import 'package:clinic/provider/event/user_event.dart';
import 'package:clinic/provider/repository/user_repository.dart';
import 'package:clinic/provider/state/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepo;
  UserBloc({required this.userRepo}) : super(UserInitialState()) {
    on<FetchUser>((event, emit) async {
      emit(UserLoadingState());

      try {
        final users = await userRepo.fetchAllUser();
        emit(UserLoadCompleteState(users: users));
      } on Exception catch (e) {
        emit(UserErrorState(error: e.toString()));
      }
    });
  }
}
