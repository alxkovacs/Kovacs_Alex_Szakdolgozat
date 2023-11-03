import 'package:application/view/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

class StartScreenViewModel {
  void goToNextScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => SignUpScreen()));
  }
}
