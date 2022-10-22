import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constants{

  static String weblink = "http://artan.in/api/";
  static Color mainTheme = const Color(0xFFC12026);
  static String semibold = "Semibold";
  static String regular = "Regular";
  static String medium = "Medium";


  static showtoast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.grey,
      // backgroundColor: Colors.white,
      // textColor: Colors.grey.shade900,
    );
  }
}

class Routes{
  static const String LOGIN = "login";
  static const String LOGOUT = "logout";


}