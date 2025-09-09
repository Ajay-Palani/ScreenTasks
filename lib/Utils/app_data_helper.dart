import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';



abstract class AppDataHelper{
  AppDataHelper._();

  static String appName='Prashanth Fertility Care';
  static final GlobalKey<NavigatorState> navKey=GlobalKey<NavigatorState>();
  
  static bool isEmailValid(String email)=> RegExp(r"^[A-Z0-9a-z._-]+@[a-zA-Z0-9_-]+\.[a-zA-Z]+").hasMatch(email);
  static BuildContext? rootContext = AppDataHelper.navKey.currentState?.overlay?.context;
}

