import 'dart:async';

import 'package:application/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserModel?> {
  StreamSubscription<User?>? _authSubscription;

  UserNotifier() : super(null) {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        // Frissítsd a felhasználói állapotot, ha be van jelentkezve
        _loadUserData(user.uid);
      } else {
        // Állítsd az állapotot null-ra, ha a felhasználó kijelentkezett
        state = null;
      }
    });
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final userData = userDoc.data();
      if (userData != null) {
        // Állítsd be a felhasználó állapotát a UserModel objektummal
        state = UserModel(firstName: userData['firstname']);
      }
    } catch (e) {
      // Kezeld az esetleges hibákat
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
