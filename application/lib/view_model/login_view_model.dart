import 'package:application/view/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInViewModel {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  Future<bool> submitLogIn(String enteredEmail, String enteredPassword) async {
    try {
      final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: enteredEmail, password: enteredPassword);
      return true; // Sikeres regisztráció
    } on FirebaseAuthException catch (err) {
      return false; // Sikertelen regisztráció
    }
  }

  void goToNextScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('signup', (Route<dynamic> route) => false);
  }
}
