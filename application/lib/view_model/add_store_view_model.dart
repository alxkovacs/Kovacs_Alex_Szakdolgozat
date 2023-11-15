import 'package:application/providers/user_provider.dart';
import 'package:application/view/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddStoreViewModel {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  Future<bool> addStore(String enteredStoreName, String enteredPostCode,
      String enteredCity, String enteredAddress) async {
    try {
      await FirebaseFirestore.instance.collection('stores').doc().set({
        'storeName': enteredStoreName,
        'postcode': enteredPostCode,
        'city': enteredCity,
        'address': enteredAddress,
      });

      return true; // Sikeres regisztráció
    } catch (err) {
      return false; // Sikertelen regisztráció
    }
  }

  void goToNextScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('signup', (Route<dynamic> route) => false);
  }
}
