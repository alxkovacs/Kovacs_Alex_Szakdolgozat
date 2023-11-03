import 'package:application/view/screens/login_screen.dart';
import 'package:flutter/material.dart';

class LogInViewModel {
  void goToNextScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('signup', (Route<dynamic> route) => false);
  }
}
