import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:task3/verifysuccess.dart';

class EmailVerify extends StatefulWidget {
  String? email;
  String? otp;
  EmailVerify(this.email, this.otp, {super.key});

  @override
  State<EmailVerify> createState() => _EmailVerifyState(email, otp);
}

class _EmailVerifyState extends State<EmailVerify> {
  String? email;
  String? otp;
  String? otpError;
  TextEditingController otpController = TextEditingController();
  _EmailVerifyState(this.email, this.otp);
  Timer? timer;
  int secondsremain = 30;
  bool _enableResend = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getTimer();
    super.initState();
  }

  void getTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsremain > 0) {
        setState(() {
          secondsremain--;
        });
      } else {
        setState(() {
          _enableResend = true;
        });
      }
    });
  }

  void resendOtp() {
    setState(() {
      secondsremain = 30;
      _enableResend = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Otp is: ${otp}')));
      print('Resend Otp:${otp}');
      getTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromARGB(255, 3, 56, 99),
                    ),
                  ),
                  SizedBox(width: 40),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Verify Email Address',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 3, 56, 99),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Image.asset('assets/image/Img4.png', fit: BoxFit.contain),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Verify the code sent to ',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${this.email}',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(255, 116, 118, 216),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Pinput(
                  controller: otpController,
                  length: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter otp';
                    } else if (value != otp) {
                      return 'Incorrect Pin';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Resend confirmation code ',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: (_enableResend == false)
                            ? '00:${secondsremain}'
                            : '',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(255, 116, 118, 216),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _enableResend ? resendOtp : null,
              child: Text('Resend OTP'),
            ),
            Container(
              width: width,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: width * 0.9,
                  height: height * 0.04,
                  child: MaterialButton(
                    color: const Color.fromARGB(255, 116, 118, 216),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuccessfullyVerified(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Confirm Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
