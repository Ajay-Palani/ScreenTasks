import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SendMessageEvent extends MessageEvent{
  String message;
  SendMessageEvent(this.message);
}
class ReceiveMessageEvent extends MessageEvent{}

class MessageState extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MessageScreenLoadingState extends MessageState{
}
class SendMessageSuccessState extends MessageState{
  bool isMessageEnter;
  String message;
  SendMessageSuccessState(this.isMessageEnter ,this.message);
}
class SendMessageErrorState extends MessageState{
  var error;
  SendMessageErrorState(this.error);
}
class ReceiveMessageSuccessState extends MessageState{
  var rmessage;
  ReceiveMessageSuccessState(this.rmessage);
}
class ReceiveMessageErrorState extends MessageState{
  var rerror;
  ReceiveMessageErrorState(this.rerror);
}

class MessageBloc extends Bloc<MessageEvent, MessageState>{
  bool? isMessageEnter;

  MessageBloc():super(MessageScreenLoadingState()){
    on<SendMessageEvent>((event, emit) {
      try{
        if(event.message.isEmpty || event.message==''){
          emit(SendMessageSuccessState(false, ''));
        }
        else{
          emit(SendMessageSuccessState(false, event.message));
        }
      }catch(e){
        emit(SendMessageErrorState('Failed to send'));
      }

    },);
  }
}