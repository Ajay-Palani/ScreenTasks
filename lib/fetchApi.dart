import 'dart:convert';

import 'package:apiintegration/apimethods.dart';
import 'package:flutter/material.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  List<dynamic> users = [];

  getDetails() async {
    String response = await Apimethods().getData();
    var data = jsonDecode(response);
    setState(() {
      users = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index];
            return Card(
              child: Row(
                children: [
                  SizedBox(
                    width: 300,
                    height: 200,
                    // child: Image.network(
                    //   user['thumbnailUrl'],
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Album Id: ${user['albumId']}'),
                        Text('Id: ${user['id']}'),
                        Text('Title:${user['title']}'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
