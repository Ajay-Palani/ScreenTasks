import 'package:flutter/material.dart';
import 'package:task1/Screen1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Login(title: 'Flutter Demo Home Page'),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key, required String title});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? emailError;
  String? PasswordError;

  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    var _errorText;
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.5,
          color: const Color.fromARGB(255, 222, 221, 217),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: Text(
                        'Email*',
                        style: TextStyle(color: Colors.black),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),

                      errorText: emailError,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          emailError = 'Please Enter Email';
                        } else if (!RegExp(
                          r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
                        ).hasMatch(value)) {
                          emailError = 'Please Enter Valid Email';
                        } else {
                          emailError = null;
                        }
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: isPasswordVisible,
                    decoration: InputDecoration(
                      label: Text(
                        'Password',
                        style: TextStyle(color: Colors.black),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          (isPasswordVisible == false
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                      errorText: PasswordError,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          PasswordError = 'Please enter password';
                        } else if (value.isNotEmpty && value.length < 8) {
                          PasswordError =
                              'Please should be minimum 8 characters';
                        } else {
                          PasswordError = null;
                        }
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topRight,
                    child: MaterialButton(
                      onPressed: () {
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        if (emailError == null && PasswordError == null) {
                          print('Email:${email} Password:${password}');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return Screen1(email, password);
                              },
                            ),
                          );
                        }
                      },
                      child: Text('Login'),
                      textColor: Colors.black,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
