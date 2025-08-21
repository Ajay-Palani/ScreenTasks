import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_picker/image_picker.dart';

import '../Bloc/chatBloc.dart';
import 'individualChat.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {

  List<dynamic> users=[];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>  ChatBloc(),
      child: DefaultTabController(
        length: 4,
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            final tabControl = DefaultTabController.of(context);

            tabControl.addListener(() {
              if (tabControl.index == 1 && tabControl.indexIsChanging) {
                context.read<ChatBloc>().add(LoadChatEvent());
              }
            });

            return Scaffold(
              appBar: AppBar(
                backgroundColor:  Color.fromARGB(237, 7, 94, 80),
                title:  Text(
                  'WhatsApp',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                actions: [
                  IconButton(
                    icon:  Icon(Icons.camera_alt),
                    color: Colors.white,
                    onPressed: () {
                      ImagePicker().pickImage(source: ImageSource.camera);
                    },
                  ),
                   SizedBox(width: 20),
                   Icon(Icons.search, color: Colors.white),
                  PopupMenuButton(
                    iconColor: Colors.white,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(child: Text('New Community')),
                        PopupMenuItem(child: Text('New Broadcast')),
                        PopupMenuItem(child: Text('Linked Device')),
                        PopupMenuItem(child: Text('Starred')),
                        PopupMenuItem(child: Text('Payments')),
                        PopupMenuItem(child: Text('Read All')),
                        PopupMenuItem(child: Text('Settings')),
                      ];
                    },
                  ),
                ],
                bottom:  TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.white,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [Tab(icon: Icon(Icons.groups, color: Colors.white)), SizedBox(width: 80, child: Tab(child: Text('Chats', style: TextStyle(color: Colors.white)))),
                    SizedBox(width: 80, child: Tab(child: Text('Status', style: TextStyle(color: Colors.white)))),
                    SizedBox(width: 80, child: Tab(child: Text('Calls', style: TextStyle(color: Colors.white)))),
                  ],
                ),
              ),
              body: BlocListener<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state is ChatError) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          state.error,
                          style:  TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        actions: [
                          OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child:  Text("Ok"))
                        ],
                      ),
                    );
                  }
                },
                child: TabBarView(
                  children: [ Center(child: Text("Community")),
                    BlocBuilder<ChatBloc,ChatState>(builder: (context, state) {
                      return getChats(state);
                    },),
                     Center(child: Text("Status")),
                     Center(child: Text("Calls")),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getChats(ChatState state) {
    if (state is LoadedChats) {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) =>  Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.grey[300]!,
          child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(radius: 25, backgroundColor: Colors.white),
              tileColor: Colors.black12,
            ),
          ),
        ),
      );
    } else if (state is ChatSuccess) {
       users = state.users;
      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  Individualchat(users[index])),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage("${users[index]['avatar']}"),
              radius: 30,
            ),
            title: Text("${users[index]['first_name']} ${users[index]['last_name']}", style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text("${users[index]['email']}", style:  TextStyle(fontSize: 16, color: Colors.black54),
            ), trailing:  Text("7:30", style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ),
      );
    } else if (state is ChatEmpty) {
      return  Center(child: Text("No Data Available"));
    } else if (state is ChatError) {
      return Center(child: Text('No Data'));
    }
    return SizedBox();
  }
}
