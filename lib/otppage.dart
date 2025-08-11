import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class OTPPage extends StatefulWidget {
  final String otp;
  const OTPPage(this.otp, {super.key});

  @override
  State<OTPPage> createState() => _OTPPageState(this.otp);
}

class _OTPPageState extends State<OTPPage> {
  final String otpGet;
  String? otpError;
  _OTPPageState(this.otpGet);
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print('OtpPage:${this.otpGet}');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Verify OTP',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Pinput(
              length: 6,
              controller: otpController,
              defaultPinTheme: PinTheme(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 195, 213, 238),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              errorPinTheme: PinTheme(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => (value == otpGet) ? null : 'Incorrect Pin',
            ),
            SizedBox(height: 20),
            MaterialButton(
              color: const Color.fromARGB(255, 215, 97, 136),

              onPressed: () {
                print('Otp: ${otpGet}, OtpController: ${otpController}');
                setState(() {
                  if (otpGet == otpController.text &&
                      otpController.text != '') {
                    print('Verified');
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => Home()));
                  }
                });
              },
              child: Text('Verify', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome',
          style: TextStyle(
            color: Colors.pink,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
