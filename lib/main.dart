import 'package:flutter/material.dart';
import 'package:ivf/Utils/app_data_helper.dart';
import 'Screens/Splash/splash.dart';
import 'package:ivf/Screens/NewUser/basic_details.dart';
import 'Screens/Dashboard/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: AppDataHelper.navKey,
      home: Welcomepage(),
    );
  }
}
