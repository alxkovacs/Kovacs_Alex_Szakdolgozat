import 'package:application/service/profile_screen_service.dart';
import 'package:flutter/material.dart';

class ProfileScreenViewModel extends ChangeNotifier {
  final ProfileScreenService _service = ProfileScreenService();
  String firstName = '';
  bool isLoading = false;

  ProfileScreenViewModel() {
    _service.authStateChanges().listen((user) {
      if (user != null) {
        loadUserData();
      }
    });
  }

  Future<void> loadUserData() async {
    isLoading = true;
    notifyListeners();

    var userData = await _service.getUserData(_service.currentUser!.uid);
    if (userData != null) {
      firstName = userData['firstname'] ?? '';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateFirstName(String newFirstName) async {
    if (newFirstName.length >= 3) {
      isLoading = true;
      notifyListeners();

      await _service.updateUserData(
          _service.currentUser!.uid, {'firstname': newFirstName});
      firstName = newFirstName;

      isLoading = false;
      notifyListeners();
    }
  }
}
