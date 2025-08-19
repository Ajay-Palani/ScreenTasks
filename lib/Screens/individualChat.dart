import 'package:flutter/material.dart';

class Individualchat extends StatefulWidget {
  Map<String, dynamic> user= {};
  Individualchat(this.user, {super.key});

  @override
  State<Individualchat> createState() => _IndividualchatState(this.user);
}

class _IndividualchatState extends State<Individualchat> {
  Map<String, dynamic> user={};
  _IndividualchatState(this.user);
  bool isMessageEnter = false;
  List<String> messages = [];

  sendMessage() {
    if (messageController.text != "") {
      setState(() {
        messages.add(messageController.text);
        messageController.clear();
        isMessageEnter = false;
      });
    } else {
      return null;
    }
  }

  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(237, 7, 94, 80),
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),

              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 223, 220, 220),
                    ),
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('${user['avatar']}'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  '${user['first_name']} ${user['last_name']}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            iconColor: Colors.white,
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(value: 'newgroup', child: Text('New group')),
                PopupMenuItem(
                  value: 'newCommunity',
                  child: Text('New community'),
                ),
                PopupMenuItem(
                  value: 'newBroadcast',
                  child: Text('New broadcast'),
                ),
                PopupMenuItem(
                  value: 'linkedDevices',
                  child: Text('Linked devices'),
                ),
                PopupMenuItem(value: 'starred', child: Text('Starred')),
                PopupMenuItem(value: 'payments', child: Text('Payments')),
                PopupMenuItem(value: 'readAll', child: Text('Read all')),
                PopupMenuItem(value: 'settings', child: Text('Settings')),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 108, 224, 111),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: ('${messages[index]}\n'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            WidgetSpan(
                              child: Text(
                                '${TimeOfDay.now().format(context)}',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        prefixIcon: Icon(Icons.insert_emoticon),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.attach_file),
                              SizedBox(width: 10),
                              Icon(Icons.camera_alt),
                            ],
                          ),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardAppearance: Brightness.light,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      controller: messageController,
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            isMessageEnter = true;
                          } else {
                            isMessageEnter = false;
                          }
                        });
                      },
                    ),
                  ),
                  isMessageEnter
                      ? IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendMessage();
                    },
                  )
                      : Icon(
                    Icons.mic,
                    color: Color.fromARGB(255, 15, 109, 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
