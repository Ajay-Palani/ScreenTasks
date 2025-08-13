import 'dart:math';

import 'package:apiintegration/apimethods.dart';
import 'package:apiintegration/whatsAppchat.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class FetchPage extends StatefulWidget {
  const FetchPage({super.key});

  @override
  State<FetchPage> createState() => _FetchPageState();
}

class _FetchPageState extends State<FetchPage> {
  List<dynamic> users = [];

  getPage() async {
    final response = await Apimethods().getPage2();
    setState(() {
      users = response['data'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'WhatsApp',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color.fromARGB(237, 7, 94, 80),
          actions: [
            Icon(
              Icons.camera_alt_outlined,
              color: const Color.fromARGB(200, 255, 255, 255),
            ),
            SizedBox(width: 20),
            Icon(Icons.search, color: const Color.fromARGB(200, 255, 255, 255)),
            PopupMenuButton(
              iconColor: Color.fromARGB(200, 255, 255, 255),
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

          bottom: PreferredSize(
            preferredSize: Size(38, 50),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.white,
              tabs: [
                SizedBox(
                  width: 30,
                  child: Tab(
                    icon: Icon(Icons.groups, color: Colors.white70, size: 25),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Tab(
                    child: Text(
                      'Chats',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),

                SizedBox(
                  width: 80,
                  child: Tab(
                    child: Text(
                      'Status',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Tab(
                    child: Text(
                      'Calls',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Community')),
            ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          print("Users:${user}");
                          return Whatsappchat(user);
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('${user['avatar']}'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${user['first_name']} ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '${user['last_name']}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '11:39',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${user['email']}',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Center(child: Text('Status')),
            Center(child: Text('Calls')),
          ],
        ),
      ),
    );
  }
}
