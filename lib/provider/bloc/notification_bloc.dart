import 'package:clinic/provider/event/notification_event.dart';
import 'package:clinic/provider/repository/notification_repository.dart';
import 'package:clinic/provider/state/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc<ResponseModel>
    extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepo;

  NotificationBloc({required this.notificationRepo})
      : super(NotificationInitialState()) {
    on<FetchMemberNotification>((event, emit) async {
      emit(NotificationLoadingState());

      try {
        final reserve = await notificationRepo.fetchMemberReserveNotification();
        emit(NotificationLoadCompleteState(reserve: reserve));
      } on Exception catch (e) {
        emit(NotificationErrorState(error: e.toString()));
      }
    });

    on<FetchAllNotification>((event, emit) async {
      emit(NotificationLoadingState());

      try {
        final reserves = await notificationRepo.fetchAdminReserveNotification();
        emit(AllNotificationLoadCompleteState(reserves: reserves));
      } on Exception catch (e) {
        emit(NotificationErrorState(error: e.toString()));
      }
    });
  }
}
