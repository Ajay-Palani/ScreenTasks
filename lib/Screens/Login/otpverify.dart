import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivf/Bloc/login_bloc.dart';
import 'package:ivf/Utils/app_colors.dart';
import 'package:pinput/pinput.dart';
import 'package:ivf/Screens/NewUser/basic_details.dart';
import 'package:ivf/Screens/Dashboard/dashboard.dart';

class OtpVerifyWrapper extends StatelessWidget {
  final TextEditingController phone;

  const OtpVerifyWrapper(this.phone, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      LoginBloc()..add(SendOtpEvent(int.parse(phone.text))),
      child: OtpVerify(phone),
    );
  }
}

class OtpVerify extends StatefulWidget {
  final TextEditingController phone;

  const OtpVerify(this.phone, {super.key});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final TextEditingController otpController = TextEditingController();
  Timer? timer;
  int otpTime = 30;
  bool isResendEnabled = false;

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  void startTimer({int duration = 30}) {
    timer?.cancel();
    setState(() {
      otpTime = duration;
      isResendEnabled = false;
    });

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (otpTime > 0) {
        setState(() {
          otpTime--;
        });
      } else {
        setState(() {
          isResendEnabled = true;
        });
        timer?.cancel();
      }
    });
  }

  void _verifyOtpWithBloc(BuildContext context) {
    if (otpController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter OTP")));
      return;
    }

    final int phone = int.parse(widget.phone.text);
    final int otp = int.parse(otpController.text);

    BlocProvider.of<LoginBloc>(context).add(VerifyOtpEvent(phone, otp));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final defaultPinTheme = PinTheme(
      width: 55,
      height: 55,
      textStyle:  TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
      decoration: BoxDecoration(
        color: AppColors.textColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
    );

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is StartTimerState) {
          startTimer(duration: 30);
        } else if (state is OtpVerifySuccess) {
          // Navigate after verification
          if (state.isNewUser) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NewUser()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Dashboard(state.token)),
            );
          }
        } else if (state is OtpVerifyError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.bgColor,
            body: SizedBox(
              width: width,
              height: height,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: width,
                          height: height * 0.27,
                          child: Image.asset(
                            'assets/images/login.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top:225,
                          child: Container(
                            width: width,
                            height: height * 0.75,
                            decoration: BoxDecoration(
                              color: AppColors.bgColor,
                              borderRadius:  BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                            ),
                            child: SingleChildScrollView(
                              padding:  EdgeInsets.all(16),
                              child: Padding(
                                padding:  EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     SizedBox(height: 5),
                                    Align(
                                      child: Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          color: AppColors.purple,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                     SizedBox(height: 25),
                                     Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        'Mobile Number',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 50,child: TextFormField(
                                      readOnly: true,
                                      controller: widget.phone,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.borderColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.borderColor),
                                        ),
                                        filled: true,
                                        fillColor: AppColors.textColor,
                                        prefix: Text('+91'),
                                        hintText: 'xxxxxxxxxx',
                                        border:
                                         OutlineInputBorder(gapPadding: 1),
                                      ),
                                    ),),
                                     SizedBox(height: 20),
                                     Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Enter OTP',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Pinput(
                                      length: 6,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      controller: otpController,
                                      defaultPinTheme: defaultPinTheme,
                                      focusedPinTheme:
                                      defaultPinTheme.copyWith(
                                        decoration: defaultPinTheme.decoration!
                                            .copyWith(
                                          border: Border.all(
                                              color: AppColors.buttonColor,
                                              width: 2),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    otpMessage(),
                                    SizedBox(height: 175),
                                    SizedBox(
                                      height: height * 0.06,
                                      width: width,
                                      child: MaterialButton(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        onPressed: () =>
                                            _verifyOtpWithBloc(context),
                                        color: AppColors.buttonColor,
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          'Verify',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget otpMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Didn't get it? ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        if (!isResendEnabled)
          Text(
            'Resend by $otpTime sec',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.buttonColor,
            ),
          )
        else
          TextButton(
            onPressed: () {
              startTimer(duration: 30);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(0),
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Resend OTP',
              style: TextStyle(
                color: AppColors.buttonColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
