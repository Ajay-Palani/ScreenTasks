import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task5/Api/apiMethods.dart';

class CubitChatEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadCubitChatEvent extends CubitChatEvent{}

class CubitChatState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class InitialState extends CubitChatState{}
class CubitLoadingChatState extends CubitChatState{}
class CubitChatLoadSuccess extends CubitChatState{
  List<dynamic> cubit_users=[];
  CubitChatLoadSuccess(this.cubit_users);
}
class CubitChatLoadEmpty extends CubitChatState{}
class CubitChatLoadError extends CubitChatState{
  String error;
  CubitChatLoadError(this.error);
}


class CubitChatBloc extends Bloc<CubitChatEvent, CubitChatState>{
  CubitChatBloc():super(InitialState());


  @override
  Stream<CubitChatState> mapEventToState(CubitChatEvent event) async*{
    if(event is LoadCubitChatEvent){
      yield CubitLoadingChatState();
      try{
        var response=await ApiMethods().getChats();
        var users= response['data'];
        if(users==null || users.isEmpty){
          yield CubitChatLoadEmpty();
        }
        else {
          yield CubitChatLoadSuccess(users);
        }
      }catch(e){
        yield CubitChatLoadError('Failed to load');
      }
    }
  }
}