import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ivf/Api/api_methods.dart';

abstract class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDashboardEvent extends DashboardEvent {
  final String token;
  FetchDashboardEvent(this.token);

  @override
  List<Object?> get props => [token];
}

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final Map<String, dynamic> userData;
  DashboardSuccess(this.userData);

  @override
  List<Object?> get props => [userData];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<FetchDashboardEvent>((event, emit) async {
      emit(DashboardLoading());
      try {
        final response = await ApiMethods().getData();
        if (response['data'] != null && response['data']['user'] != null) {
          emit(DashboardSuccess(response['data']['user']));
        } else {
          emit(DashboardError("No user data found"));
        }
      } catch (e) {
        emit(DashboardError("Failed to load dashboard"));
      }
    });
  }
}