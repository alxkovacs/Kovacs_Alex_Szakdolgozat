import 'package:application/view/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

class StartViewModel {
  void goToNextScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('signup', (Route<dynamic> route) => false);
  }
}
