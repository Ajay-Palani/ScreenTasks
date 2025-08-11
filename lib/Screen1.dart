import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  final String? email;
  final String? password;
  const Screen1(this.email, this.password); 
  
   @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width*1,
        height: MediaQuery.of(context).size.height*1,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Email:     ${email}'),
                Text('Password: ${password}'),
              ],
            ),
          ),
      ),
    );
  }  
}

