import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  static const Color mainColor = Color.fromRGBO(67, 153, 182, 1.0);
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xffff9a9e),
      Color(0xfffad0c4),
      Color(0xfffad0c4),
    ],
  );
}
