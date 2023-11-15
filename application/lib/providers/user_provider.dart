import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, String>((ref) {
  return UserNotifier()..checkAuthStatus();
});

class UserNotifier extends StateNotifier<String> {
  UserNotifier() : super('');

  void setUserFirstName(String firstName) {
    state = firstName;
  }

  // Ellenőrzi a bejelentkezési állapotot, és frissíti a felhasználó nevét, ha be van jelentkezve
  Future<void> checkAuthStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final userData = userDoc.data();
      if (userData != null) {
        setUserFirstName(userData['firstname']);
      }
    }
  }
}
