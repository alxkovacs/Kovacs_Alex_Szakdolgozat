import 'package:application/utils/roots.dart';
import 'package:application/view/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreenViewModel {
  void goToStartScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        Roots.startScreen, (Route<dynamic> route) => false);
  }

  void goToProfileScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }
}
