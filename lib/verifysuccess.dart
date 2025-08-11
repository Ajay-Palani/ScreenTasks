import 'package:flutter/material.dart';
import 'package:task3/main.dart';

class SuccessfullyVerified extends StatefulWidget {
  const SuccessfullyVerified({super.key});

  @override
  State<SuccessfullyVerified> createState() => _SuccessfullyVerifiedState();
}

class _SuccessfullyVerifiedState extends State<SuccessfullyVerified> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color.fromARGB(255, 3, 56, 99),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/image/Background_Complete.png',
                        opacity: AlwaysStoppedAnimation(1.0),
                      ),
                      Positioned(
                        left: 40,
                        top: 10,
                        child: Image.asset('assets/image/shield.png'),
                      ),
                    ],
                  ),
                  Text(
                    'Successfully Created',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your password has been successfully created',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: MaterialButton(
                          color: const Color.fromARGB(255, 116, 118, 216),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SolaceIntro(),
                              ),
                            );
                          },
                          child: Text(
                            'Login',
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
          ),
        ],
      ),
    );
  }
}
