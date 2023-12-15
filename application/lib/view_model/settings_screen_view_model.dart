import 'package:application/utils/roots.dart';
import 'package:application/view/screens/profile_screen.dart';
import 'package:application/view_model/base_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreenViewModel extends ChangeNotifier {
  void resetSelectedIndex(BuildContext context) {
    Provider.of<BaseScreenViewModel>(context, listen: false).selectedIndex = 0;
    notifyListeners();
  }

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
