import 'package:clinic/model/reserve_model.dart';
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
        final cancel =
            await notificationRepo.fetcCancelhMemberReserveNotification();

        List<ReserveModel> notif = [];
        if (reserve.isNotEmpty) notif.addAll(reserve);
        if (cancel.isNotEmpty) notif.addAll(cancel);

        emit(NotificationLoadCompleteState(reserve: notif));
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
