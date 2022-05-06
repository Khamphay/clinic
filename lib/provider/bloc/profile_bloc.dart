import 'package:clinic/provider/event/profile_event.dart';
import 'package:clinic/provider/repository/profile_repository.dart';
import 'package:clinic/provider/state/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepo;
  ProfileBloc({required this.profileRepo}) : super(ProfileInitialState()) {
    on<FetchUser>((event, emit) async {
      emit(ProfileLoadingState());

      try {
        final profiles = await profileRepo.fetchProfile();
        emit(ProfileLoadCompleteState(customers: profiles));
      } on Exception catch (e) {
        emit(ProfileErrorState(error: e.toString()));
      }
    });
  }
}
