import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:ivf/Utils/app_colors.dart';
import 'package:ivf/Utils/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivf/Repositary/app_repo.dart';
import 'package:ivf/Bloc/login_bloc.dart';
import 'package:ivf/Screens/NewUser/basic_details.dart';
import 'package:ivf/Utils/app_alert_controller.dart';
import 'package:ivf/Repositary/api_token.dart';
import 'package:ivf/Screens/Dashboard/dashboard.dart';


class OtpVerify extends StatefulWidget {
  final TextEditingController phone;

  const OtpVerify(this.phone, {super.key});

  @override
  State<OtpVerify> createState() => _OtpVerifyState(this.phone);
}

class _OtpVerifyState extends State<OtpVerify> {
  final TextEditingController phone;

  _OtpVerifyState(this.phone);
  final TextEditingController otpController = TextEditingController();
  final formkey= GlobalKey<FormState>();
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

    timer = Timer.periodic(Duration(seconds: 1), (timing) {
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


  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if(state is VerifyOtpSuccessState){
            setToken(state.data['session']['token']);
            setId(state.data['data']['user']['_id']);
            bool newUser= state.data['data']['user']['isNewUser'];
            if(newUser){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewUser(),));
            }
            else{
              Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(),));
            }

          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          final defaultPinTheme = PinTheme(
            width: 50,
            height: 50,
            textStyle: TextStyle(
                fontSize: 20, color: AppColors.black, fontWeight: FontWeight.normal),
            decoration: BoxDecoration(
              color: AppColors.textColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColors.borderColor),
            ),
          );

          return Scaffold(
            backgroundColor: AppColors.bgColor,
            body: Form(
              key: formkey,
              child: SizedBox(
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
                          top: 225,
                          child: Container(
                            width: width,
                            height: height * 0.75,
                            decoration: BoxDecoration(
                              color: AppColors.bgColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                            ),
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(16),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Align(
                                      child: CommonPack().regularText(
                                          text: 'LOGIN',
                                          fontWeight: FontWeight.w500,
                                          fontsize: 24,
                                          color: AppColors.purple),
                                    ),
                                    SizedBox(height: 25),
                                    Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: CommonPack().regularText(
                                          text: 'Mobile Number',
                                          color: AppColors.black,
                                          fontsize: 20,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(height: 5),
                                    SizedBox(
                                      height: 50,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: phone,
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
                                          border: OutlineInputBorder(gapPadding: 1),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: CommonPack().regularText(
                                          text: 'Enter OTP',
                                          fontWeight: FontWeight.w400,
                                          fontsize: 20,
                                          color: AppColors.black,
                                        )),
                                    SizedBox(height: 20),
                                    Pinput(
                                      length: 6,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: otpController,
                                      defaultPinTheme: defaultPinTheme,
                                      focusedPinTheme: defaultPinTheme.copyWith(
                                        decoration:
                                        defaultPinTheme.decoration!.copyWith(
                                          border: Border.all(
                                              color: AppColors.buttonColor, width: 1),
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
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)),
                                          onPressed: () {
                                            if(formkey.currentState!.validate()){
                                              var payload= Login(phone: phone.text, otp: otpController.text);
                                              print('Phone: ${phone.text}, Otp: ${otpController.text}');
                                              BlocProvider.of<LoginBloc>(context).add(VerifyOtpEvent(payload, context));
                                            }
                                          },
                                          color: AppColors.buttonColor,
                                          padding: EdgeInsets.all(10),
                                          child: CommonPack().regularText(
                                              text: 'Verify',
                                              color: AppColors.white,
                                              fontsize: 20,
                                              fontWeight: FontWeight.w600)),
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
            ),),
          );
        },),
      ),
    );


  }

  Widget otpMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CommonPack().regularText(
            text: "Didn't get it? ",
            color: AppColors.black,
            fontsize: 14,
            fontWeight: FontWeight.w300),
        if (!isResendEnabled)
          CommonPack().regularText(
              text: 'Resend by ${otpTime} sec',
              fontsize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.buttonColor)
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
              child: CommonPack().regularText(
                text: 'Resend OTP',
                color: AppColors.buttonColor,
                fontWeight: FontWeight.w500,
                fontsize: 14,
              )),
      ],
    );
  }
}
