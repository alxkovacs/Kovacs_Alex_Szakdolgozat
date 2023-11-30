import 'package:application/utils/roots.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/base_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> submitLogIn(String enteredEmail, String enteredPassword,
      BuildContext context, WidgetRef ref) async {
    isLoading = true;

    try {
      await _firebase.signInWithEmailAndPassword(
          email: enteredEmail, password: enteredPassword);

      isLoading = false;
      return true;
    } on FirebaseAuthException {
      isLoading = false;
      if (context.findRenderObject() != null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(TranslationEN.loginFailed)),
        );
      }
      return false;
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty || !value.contains('@')) {
      return TranslationEN.emailValidator;
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().length < 6) {
      return TranslationEN.passwordValidator;
    }

    return null;
  }

  void goToLogInScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        Roots.logInScreen, (Route<dynamic> route) => false);
  }

  void goToStartScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        Roots.startScreen, (Route<dynamic> route) => false);
  }

  void goToBaseScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const BaseScreen(),
        transitionDuration: Duration.zero,
      ),
      (Route<dynamic> route) => false,
    );
  }
}
