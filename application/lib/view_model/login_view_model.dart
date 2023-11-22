import 'package:application/model/user.dart';
import 'package:application/providers/products_provider.dart';
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
        // Beállítjuk a UserModel típusú felhasználói állapotot
        ref.read(userProvider.notifier).state =
            UserModel(firstName: userData['firstname']);
      }
      // Ha van valamilyen felhasználó-specifikus termék lista, akkor valószínűleg
      // szükséged lesz a felhasználó UID-jára az adatok frissítéséhez.
      // final userId = userCredentials.user!.uid;
      ref.refresh(productsProvider(
          '')); // Frissítjük a termékeket az új felhasználói ID alapján.
      return true; // Sikeres bejelentkezés
    } on FirebaseAuthException catch (err) {
      // Kezeld a FirebaseAuthException hibákat itt
      return false; // Sikertelen bejelentkezés
    }
  }

  void goToNextScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('signup', (Route<dynamic> route) => false);
  }
}
