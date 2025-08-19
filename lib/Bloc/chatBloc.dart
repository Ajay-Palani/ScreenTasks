import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task5/Api/apiMethods.dart';

abstract class ChatEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class LoadChat extends ChatEvent{}
abstract class ChatState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class InitialState extends ChatState{}
class LoadedChats extends ChatState{}
class ChatSuccess extends ChatState{
  List<dynamic> users=[];
  ChatSuccess(this.users);
}
class ChatEmpty extends ChatState{}
class ChatError extends ChatState{
  String error;
  ChatError(this.error);

}

class ChatBloc extends Bloc<ChatEvent, ChatState>{
  ChatBloc():super(InitialState()) {
    on<LoadChat>((event, emit) async {
      emit(LoadedChats());
      try{
        final response= await ApiMethods().getChats();
        final users=response['data'];
        if(users==null || users==''){
          emit(ChatEmpty());
        }else{
          emit(ChatSuccess(users));
        }
      }catch(e){
        final error= 'Failed to Load';
        emit(ChatError(error));
      }
    });
  }

}