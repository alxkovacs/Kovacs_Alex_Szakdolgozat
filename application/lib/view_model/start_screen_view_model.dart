import 'package:application/utils/roots.dart';
import 'package:flutter/material.dart';

class StartScreenViewModel {
  void goToNextScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        Roots.signUpScreen, (Route<dynamic> route) => false);
  }
}
