import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ivf/Api/api_methods.dart';
import 'package:ivf/Utils/app_colors.dart';

import '../Login/login.dart';

class Welcomepage extends StatefulWidget {
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ));
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:  EdgeInsets.all(10.0),
            child: Container(
              width: 100,
              height: 100,
              child: Image.asset(
                'assets/images/Prashanth.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding:  EdgeInsets.all(10.0),
            child: Text(
              'PRASHANTH FERTILITY CARE',
              style: TextStyle(
                  color: AppColors.purple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      )),
    );
  }
}
