import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import '../Api/api_methods.dart';
import '../Repositary/api_token.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends LoginEvent {
  final int phone;
  SendOtpEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class VerifyOtpEvent extends LoginEvent {
  final int phone;
  final int otp;
  VerifyOtpEvent(this.phone, this.otp);

  @override
  List<Object?> get props => [phone, otp];
}

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialOtpState extends LoginState {}

class StartTimerState extends LoginState{}

class LoadingState extends LoginState {}

class OtpVerifySuccess extends LoginState {
  final bool isNewUser;
  final String token;
  final String userId;
  OtpVerifySuccess(this.isNewUser, this.token, this.userId);

  @override
  List<Object?> get props => [isNewUser, token, userId];
}

class OtpVerifyError extends LoginState {
  final String error;
  OtpVerifyError(this.error);

  @override
  List<Object?> get props => [error];
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiMethods api = ApiMethods();

  LoginBloc() : super(InitialOtpState()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<LoginState> emit) async {
    emit(LoadingState());
    try {
      final response = await api.sendMobileNumber(event.phone);
      if (response.statusCode == 200) {
        emit(InitialOtpState());
        emit(StartTimerState());
      } else {
        emit(OtpVerifyError("Failed to send OTP"));
      }
    } catch (e) {
      emit(OtpVerifyError(e.toString()));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<LoginState> emit) async {
    emit(LoadingState());
    try {
      final response = await api.verifyOtp(event.phone, event.otp);
      final Map<String, dynamic> data = jsonDecode(response);

      if (data['status']['code'] == 200) {
        final bool isNewUser = data['data']['user']['isNewUser'];
        final String token = data['session']['token'];
        final String id = data['data']['user']['_id'];

        setToken(token);
        setId(id);

        emit(OtpVerifySuccess(isNewUser, token, id));
      } else {
        emit(OtpVerifyError(data['status']['message'] ?? "Invalid OTP"));
      }
    } catch (e) {
      emit(OtpVerifyError('Failed'));
    }
  }
}
