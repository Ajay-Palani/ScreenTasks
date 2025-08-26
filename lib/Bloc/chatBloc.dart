import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task5/Api/apiMethods.dart';

class ChatEvent extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadChatEvent extends ChatEvent{}
class ChatState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class InitialState extends ChatState{}
class LoadedChats extends ChatState{
  // List<dynamic> users=[];
  // LoadedChats(this.users);
}
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
    on<LoadChatEvent>((event, emit) async {
      emit(LoadedChats());

      try {
        final response = await ApiMethods().getChats();
        final users = response['data'];
        if(users == null || users.isEmpty){
          emit(ChatEmpty());
        } else {
          emit(ChatSuccess(users));
        }
      } catch (e) {
        emit(ChatError("Failed to load"));
      }
    });
  }
}