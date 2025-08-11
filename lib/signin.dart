import 'package:flutter/material.dart';
import 'package:task3/forgetPass.dart';
import 'package:task3/main.dart';
import 'package:task3/welcome.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? emailError;
  String? passwordError;
  bool ispasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 1, 4, 63),
          image: DecorationImage(
            image: AssetImage('assets/image/sign.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color.fromARGB(255, 3, 56, 99),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Sign into your Solace Account',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 241, 243, 245),
                      label: Text(
                        'Email',
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
                        if (value.isEmpty) {
                          emailError = 'Please Enter Email';
                        } else if (!RegExp(
                          r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9._]+\.[a-zA-Z]{2,4}$',
                        ).hasMatch(value)) {
                          emailError = 'Please Enter valid email';
                        } else {
                          emailError = null;
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: ispasswordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 241, 243, 245),
                      label: Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      errorText: passwordError,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            ispasswordVisible = !ispasswordVisible;
                          });
                        },
                        icon: Icon(
                          ispasswordVisible == false
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          passwordError = 'Please Enter Password';
                        } else if (value.length < 8) {
                          passwordError =
                              'Password must be minimum 8 characters';
                        } else {
                          passwordError = null;
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),

                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPassword(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 52, 15, 117),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: MaterialButton(
                      color: const Color.fromARGB(255, 116, 118, 216),
                      onPressed: () {
                        if (emailError == null &&
                            passwordError == null &&
                            emailController.text != '' &&
                            passwordController.text != '') {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Welcome();
                                },
                              ),
                            );
                          });
                        } else if (emailController.text == '' &&
                            passwordController.text != '') {
                          setState(() {
                            emailError = 'Please Enter Email';
                          });
                        } else if (emailController.text != '' &&
                            passwordController.text == '') {
                          setState(() {
                            passwordError = 'Please Enter Password';
                          });
                        } else if (emailController.text == '' &&
                            passwordController.text == '') {
                          setState(() {
                            emailError = 'Please Enter Email';
                            passwordError = 'Please Enter Password';
                          });
                        }
                      },
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
