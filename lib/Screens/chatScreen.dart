import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task5/Screens/individualChat.dart';

import '../Bloc/chatBloc.dart';
class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    double width= MediaQuery.of(context).size.width*1;
    double height= MediaQuery.of(context).size.height*1;
    return BlocProvider(
      create: (context) {
        return ChatBloc()..add(LoadChat()) ;
      },

      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(237, 7, 94, 80),
            title: Text('WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),), actions: [Icon(Icons.camera_alt_sharp, color: Colors.white,),SizedBox(width: 20,), Icon(Icons.search, color: Colors.white,), PopupMenuButton(
            iconColor: Colors.white,
            itemBuilder: (context) {
            return <PopupMenuEntry<String>>[PopupMenuItem(child: Text('New Community')), PopupMenuItem(child: Text('New Broadcast')), PopupMenuItem(child: Text('Linked Device')), PopupMenuItem(child: Text('Starred')),PopupMenuItem(child: Text('Payments')), PopupMenuItem(child: Text('Read All')), PopupMenuItem(child: Text('Settings'))];
          },)],
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.white,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [Tab(icon: Icon(Icons.groups, color: Colors.white,), ), SizedBox(
                  width: 80,
                    child: Tab(child: Text('Chats', style: TextStyle(color: Colors.white),),)),
                  SizedBox(
                    width: 80,
                      child: Tab(child: Text('Status', style: TextStyle(color: Colors.white),),)),
                  SizedBox(
                    width: 80,
                      child: Tab(child: Text('Calls', style: TextStyle(color: Colors.white),),))]),
          ),
          body: BlocListener<ChatBloc, ChatState>(listener: (context, state) {
            if(state is ChatError){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load')));
            }
          },child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
            return TabBarView(children: [Center(child: Text('Community'),),
              getChats(state),
              Center(child: Text('Status'),), Center(child: Text('Calls'),)]);
          },),)

        ),
      ),
    );
  }
  Widget getChats(ChatState state){
    if(state is LoadedChats){
      return Center(

        child:  Shimmer.fromColors(
          baseColor: Colors.red,
          highlightColor: Colors.grey[300]!,
          child: Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(color: Colors.red),
          ),
        )
      );
    }
    else if(state is ChatSuccess){
      final users= state.users;
      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {

        return InkWell(
          onTap: () {

            Navigator.push(context, MaterialPageRoute(builder: (context) => Individualchat(users[index]),));
          },
          child: Padding(padding: EdgeInsets.all(5), child: ListTile(leading: CircleAvatar(backgroundImage: NetworkImage('${users[index]['avatar']}'),radius: 30,),title: Text('${users[index]['first_name']} ${users[index]['last_name']}', style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),subtitle: Text('${users[index]['email']}', style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),), trailing: Text('7:30',style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),),),),
        );
      },);
    }
    else if(state is ChatEmpty){
      return Center(child: Text('No Data Available'),);
    }
    else if(state is ChatError){
      return AlertDialog(
        title: Text('${state}'),
      );
    }
    else{
      return Center();
    }
  }
}
