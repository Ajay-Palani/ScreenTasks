import 'package:flutter/material.dart';
import 'package:task3/emailotp.dart';
import 'dart:math';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  String? emailError;

  String otp = (Random().nextInt(900000) + 100000).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
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
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
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
            Padding(
              padding: EdgeInsets.all(25),
              child: Text(
                'Please write your email to receive a confirmation code to set a new password',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 241, 243, 245),
                  label: Text(
                    'Email Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  errorText: emailError,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty && value == '') {
                      emailError = 'Please Enter Email';
                    } else if (RegExp(
                          r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9._]+\.[a-zA-Z]{2,4}$',
                        ).hasMatch(value) &&
                        value.isNotEmpty) {
                      emailError = null;
                    } else {
                      emailError = 'Please Enter valid email';
                    }
                  });
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: MaterialButton(
                    color: const Color.fromARGB(255, 116, 118, 216),
                    onPressed: () {
                      if (emailError == null && emailController.text != '') {
                        String email = emailController.text;

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EmailVerify(email, otp),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('OTP is: ${otp}')),
                        );
                      } else if (emailController.text == '') {
                        setState(() {
                          emailError = 'Please Enter Email';
                        });
                      } else {
                        setState(() {
                          emailError = 'Please Enter valid email';
                        });
                      }
                    },
                    child: Text(
                      'Confirm mail',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Poppins',
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
