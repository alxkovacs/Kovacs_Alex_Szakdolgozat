import 'package:application/providers/user_provider.dart';
import 'package:application/view/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogInViewModel {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  Future<bool> submitLogIn(
      String enteredEmail, String enteredPassword, WidgetRef ref) async {
    try {
      final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: enteredEmail, password: enteredPassword);
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .get();
      final userData = userDoc.data();
      if (userData != null) {
        // Itt állítjuk be a felhasználó nevét a Riverpod segítségével.
        ref.read(userProvider.notifier).setUserFirstName(userData['firstname']);
      }
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
