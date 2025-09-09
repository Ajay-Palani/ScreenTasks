import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:ivf/Network/api_methods.dart';
import 'package:ivf/Utils/app_alert_controller.dart';
import 'package:flutter/material.dart';

class NewUser extends Equatable{
  @override
  List<Object?> get props => [];
}
class UpdateUserEvent extends NewUser{
  String userId;
  var payload;
  BuildContext context;
  UpdateUserEvent(this.userId, this.payload, this.context);
}

class NewUserState extends Equatable{
  @override
  List<Object?> get props => [];
}

class UserLoadingState extends NewUserState{}
class UpdateUserState extends NewUserState{
  var data;
  UpdateUserState(this.data);
}
class UpdateUserErrorState extends NewUserState{
  String error;
  UpdateUserErrorState(this.error);
}

class UserBloc extends Bloc<NewUser, NewUserState>{
  UserBloc():super(UserLoadingState()){
    on<UpdateUserEvent>((event, emit) async{
      emit(UserLoadingState());
      await ApiMethods().newUser(userId: event.userId, payload: event.payload, successBlock: (data) {
        emit(UpdateUserState(data));
      }, failureBlock: (exception) {
        emit(UpdateUserErrorState(exception.toString()));
        AppAlertController().showAlert(message: exception.toString(), inContext: event.context);
      },);
    },);
  }
}