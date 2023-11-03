import 'package:application/view/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SignUpViewModel {
  void goToNextScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
  }
}
