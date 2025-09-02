import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ivf/Api/api_methods.dart';
import 'package:ivf/Utils/app_colors.dart';
import 'package:ivf/Utils/common.dart';

import 'otpverify.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var formkey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width * 1;
    double height = MediaQuery
        .of(context)
        .size
        .height * 1;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Container(
        width: width,
        height: height,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: width * 1,
                      height: height * 0.27,
                      child: Image.asset(
                        'assets/images/login.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 225,
                      child: Container(
                        width: width * 1,
                        height: height * 0.75,
                        decoration: BoxDecoration(
                            color: AppColors.bgColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20))),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Form(
                            key: formkey,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      child: CommonPack().regularText(
                                          text: 'LOGIN',
                                          fontsize: 24,
                                          fontWeight: FontWeight.w500,
                                          fontfamily: 'Outfit',
                                          color: AppColors.purple)),
                                  SizedBox(height: 25),
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: CommonPack().regularText(
                                        text: 'Mobile Number',
                                        fontsize: 20,
                                        fontfamily: 'Outfit',
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(height: 5,),
                                  TextFormField(
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    controller: phoneController,
                                    validator: (value) =>
                                    (value == '' ||
                                        value == null)
                                        ? 'Please Enter Mobile Number'
                                        : (value.length == 10)
                                        ? null
                                        : 'Phone number should be 10 digits',
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10)
                                    ],
                                    decoration: InputDecoration(
                                        isDense: true,
                                        fillColor: AppColors.textColor,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.borderColor)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.borderColor)),
                                        prefix: CommonPack().regularText(text: '+91 ',fontsize: 18, fontfamily: 'Outfit',fontWeight: FontWeight.w300, color: AppColors.black),
                                        hintText: 'xxxxxxxxxxxxxxxxx',
                                        hintStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 14, fontFamily: 'Outfit', color: AppColors.black),
                                        border: OutlineInputBorder(
                                            gapPadding: 1)),
                                  ),
                                  SizedBox(height: 340),
                                  SizedBox(
                                    height: height * 0.06,
                                    width: width,
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5)),
                                      onPressed: () {
                                        if (formkey.currentState!.validate()) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OtpVerifyWrapper(
                                                        phoneController),
                                              ));
                                        }
                                      },
                                      child: CommonPack().regularText(
                                          text: 'Send OTP',
                                          color: AppColors.white,
                                          fontsize: 20,
                                          fontWeight: FontWeight.w600),
                                      color: AppColors.buttonColor,
                                      padding: EdgeInsets.all(10),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
