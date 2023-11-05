import 'package:application/model/user.dart';
import 'package:application/view/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpViewModel {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  // Future<void> submitSignUp(
  //     BuildContext context,
  //     GlobalKey<FormState> form,
  //     String enteredFirstName,
  //     String enteredEmail,
  //     String enteredPassword) async {
  //   // final isValid = form.currentState!.validate();

  //   // if (!isValid) {
  //   //   return;
  //   // }

  //   // form.currentState!.save();

  //   try {
  //     final userModel = UserModel(
  //         firstName: enteredFirstName,
  //         email: enteredEmail,
  //         password: enteredPassword);
  //     final userCredentials = await _firebase.createUserWithEmailAndPassword(
  //         email: userModel.email, password: userModel.password);
  //     if (context.mounted) {
  //       Navigator.of(context).pushNamedAndRemoveUntil(
  //         'home',
  //         (Route<dynamic> route) => false,
  //       );
  //     }
  //   } on FirebaseAuthException catch (err) {
  //     if (err.code == 'email-already-in-use') {
  //       // ...
  //     }
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).clearSnackBars();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           // content: Text(err.message ?? 'Sikertelen regisztráció!'),
  //           content: Text('Sikertelen regisztráció!'),
  //         ),
  //       );
  //     }
  //   }
  // }

  Future<bool> submitSignUp(String enteredFirstName, String enteredEmail,
      String enteredPassword) async {
    try {
      final userModel = UserModel(
          firstName: enteredFirstName,
          email: enteredEmail,
          password: enteredPassword);
      await _firebase.createUserWithEmailAndPassword(
          email: userModel.email, password: userModel.password);
      return true; // Sikeres regisztráció
    } on FirebaseAuthException catch (err) {
      return false; // Sikertelen regisztráció
    }
  }

  void goToNextScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
  }
}
