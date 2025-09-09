import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ivf/Network/api_methods.dart';
import 'package:ivf/Repositary/app_repo.dart';
import 'package:ivf/Utils/app_alert_controller.dart';


abstract class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDashboardEvent extends DashboardEvent {
  final BuildContext context;
  FetchDashboardEvent( this.context);

  @override
  List<Object?> get props => [context];
}

class FetchTimeSlotsEvent extends DashboardEvent {
  final String date;
  final BuildContext context;
  FetchTimeSlotsEvent(this.date, this.context);

  @override
  List<Object?> get props => [date, context];
}

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final DashboardModel user;
  DashboardSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class TimeSlotsLoading extends DashboardState {}

class TimeSlotsLoaded extends DashboardState {
  final List<dynamic> slots;
  TimeSlotsLoaded(this.slots);

  @override
  List<Object?> get props => [slots];
}

class TimeSlotsError extends DashboardState {
  final String message;
  TimeSlotsError(this.message);

  @override
  List<Object?> get props => [message];
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<FetchDashboardEvent>((event, emit) async {
      emit(DashboardLoading());

      await ApiMethods().dashboard(
        successBlock: (data) {
          try {
            final userJson = data['data']?['user'];
            if (userJson != null) {
              final dashboardModel = DashboardModel.fromJson(userJson);
              emit(DashboardSuccess(dashboardModel));
            } else {
              emit(DashboardError("User data not found in response"));
            }
          } catch (e) {
            emit(DashboardError("Parsing error: $e"));
          }
        },
        failureBlock: (exception) {
          emit(DashboardError(exception.toString()));
          AppAlertController().showAlert(
            message: exception.toString(),
            inContext: event.context,
          );
        },
      );
    });

    on<FetchTimeSlotsEvent>((event, emit) async {
      emit(TimeSlotsLoading());

      await ApiMethods().timeSlots(
        payload: {"date": event.date},
        successBlock: (data) {
          try {
            final slots = data['data']?['availableSlots'] ?? [];
            print('Slots:${slots}');
            emit(TimeSlotsLoaded(slots));
          } catch (e) {
            emit(TimeSlotsError("Parsing error: $e"));
          }
        },
        failureBlock: (exception) {
          emit(TimeSlotsError(exception.toString()));
          AppAlertController().showAlert(
              message: exception.toString(), inContext: event.context);
        },
      );
    });
  }
}
