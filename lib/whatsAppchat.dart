import 'package:flutter/material.dart';

class Whatsappchat extends StatefulWidget {
  Map<String, dynamic> user = {};
  Whatsappchat(this.user);

  @override
  State<Whatsappchat> createState() => _WhatsappchatState(this.user);
}

class _WhatsappchatState extends State<Whatsappchat> {
  Map<String, dynamic> user = {};
  _WhatsappchatState(this.user);
  @override
  Widget build(BuildContext context) {
    print("List:${this.user}");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        title: Text('${user['first_name']} ${user['last_name']}'),
      ),
    );
  }
}
