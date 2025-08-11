import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task3/emailotp.dart';
import 'package:task3/signin.dart';
import 'package:task3/verifysuccess.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SolaceIntro());
  }
}

class SolaceIntro extends StatefulWidget {
  const SolaceIntro({super.key});

  @override
  State<SolaceIntro> createState() => _SolaceIntroState();
}

class _SolaceIntroState extends State<SolaceIntro>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,

        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.7,

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    SizedBox(height: 20),
                    Image.asset('assets/image/Img1.png'),
                    Text(
                      'Solace',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.3,

              child: Image.asset(
                'assets/image/Img2.png',
                fit: BoxFit.contain,
                opacity: AlwaysStoppedAnimation(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
