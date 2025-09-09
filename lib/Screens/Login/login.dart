import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ivf/Network/api_methods.dart';
import 'package:ivf/Utils/app_colors.dart';
import 'package:ivf/Utils/common.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ivf/Utils/app_alert_controller.dart';
import 'package:ivf/Bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivf/Repositary/app_repo.dart';

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
    double width = MediaQuery.of(context).size.width * 1;
    double height = MediaQuery.of(context).size.height * 1;
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is SendOtpSuccessState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpVerify(phoneController),
                ));
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        // child: CommonPack().regularText(
                                        //     text: 'LOGIN',
                                        //     fontsize: 24,
                                        //     fontWeight: FontWeight.w500,
                                        //     fontfamily: 'Outfit',
                                        //     color: AppColors.purple)
                                        child: Text(
                                          'LOGIN',
                                          style: GoogleFonts.outfit(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.purple),
                                        ),
                                      ),
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
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: phoneController,
                                        validator: (value) => (value == '' ||
                                                value == null)
                                            ? 'Please Enter Mobile Number'
                                            : (value.length == 10)
                                                ? null
                                                : 'Phone number should be 10 digits',
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10)
                                        ],
                                        decoration: InputDecoration(
                                            isDense: true,
                                            fillColor: AppColors.textColor,
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        AppColors.borderColor)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        AppColors.borderColor)),
                                            prefix: CommonPack().regularText(
                                                text: '+91 ',
                                                fontsize: 16,
                                                fontfamily: 'Outfit',
                                                fontWeight: FontWeight.w300,
                                                color: AppColors.black),
                                            hintText: 'xxxxxxxxxxxxxxxxx',
                                            hintStyle: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14,
                                                fontFamily: 'Outfit',
                                                color: AppColors.black),
                                            border: OutlineInputBorder(
                                                gapPadding: 1)),
                                      ),
                                      SizedBox(height: 340),
                                      SizedBox(
                                        height: height * 0.06,
                                        width: width,
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          onPressed: () {
                                            if (formkey.currentState!
                                                .validate()) {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           OtpVerify(
                                              //               phoneController),
                                              //     )
                                              // );
                                              var payload = SendOtp(
                                                  phone: phoneController.text);
                                              BlocProvider.of<LoginBloc>(
                                                      context)
                                                  .add(SendOtpEvent(
                                                      payload, context));
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
          },
        ),
      ),
    );
  }
}
