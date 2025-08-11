import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task2/otppage.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController phoneNumberController = TextEditingController();
  String? phoneError;
  var randomNum = Random();

  String otp = (Random().nextInt(900000) + 100000).toString();

  final snackBar = SnackBar(
    content: Text('OTP Generated:'),

    action: SnackBarAction(
      label: 'Done',
      onPressed: () {
        SignUp();
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
        color: Colors.white10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 231, 96, 141),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.nunito().fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(25, 0, 0, 0),
              child: Text(
                'Welcome !',
                style: TextStyle(
                  color: const Color.fromARGB(255, 224, 86, 132),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.nunito().fontFamily,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 10, 0, 0),
              child: Text(
                'Enter your phone number to register',
                style: TextStyle(
                  color: const Color.fromARGB(255, 237, 125, 162),
                  fontSize: 20,
                  fontFamily: GoogleFonts.nunito().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 50, 0, 0),
              child: Text(
                'Mobile Number',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: GoogleFonts.nunito().fontFamily,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
              child: TextFormField(
                controller: phoneNumberController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  prefix: Text('+91 ', style: TextStyle(color: Colors.black)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 237, 239, 240),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  errorText: phoneError,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      phoneError = 'Please Enter Mobile Number';
                    } else if (value.length == 10) {
                      phoneError = null;
                    } else {
                      phoneError = 'Phone Number must be 10 digits';
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 10, 0, 0),
              child: MaterialButton(
                color: const Color.fromARGB(255, 202, 58, 106),
                onPressed: () {
                  setState(() {
                    if (phoneError == null &&
                        phoneNumberController.text != '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Your Generated OTP is: ${otp}'),
                          action: SnackBarAction(
                            label: 'Done',
                            onPressed: () {
                              SignUp();
                            },
                          ),
                        ),
                      );
                      print('Otp:${otp}');
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => OTPPage(otp)),
                      );
                    }
                  });
                },
                child: Text(
                  'Send OTP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.nunito().fontFamily,
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
