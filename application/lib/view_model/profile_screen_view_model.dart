import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreenViewModel extends ChangeNotifier {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String firstName = '';
  bool isLoading = false;

  ProfileScreenViewModel() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      this.user = user;
      if (user != null) {
        loadUserData();
      }
    });
  }

  Future<void> loadUserData() async {
    if (user != null) {
      // Adatlekérés Firestore-ból
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user!.uid).get();
      firstName = userData['firstname'];
      notifyListeners();
    }
  }

  Future<void> updateFirstName(String newFirstName) async {
    if (newFirstName.length >= 3) {
      isLoading = true;
      notifyListeners();
      // Adatfrissítés Firestore-ban
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .update({'firstname': newFirstName});
      firstName = newFirstName;
      isLoading = false;
      notifyListeners();
    }
  }
}
