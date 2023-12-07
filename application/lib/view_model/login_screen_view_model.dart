import 'package:application/service/authentication_service.dart';
import 'package:application/utils/roots.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/base_screen.dart';
import 'package:flutter/material.dart';

class LoginScreenViewModel extends ChangeNotifier {
  final AuthenticationService _userService = AuthenticationService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> submitLogin(
      String enteredEmail, String enteredPassword, BuildContext context) async {
    isLoading = true;

    final result = await _userService.loginUser(enteredEmail, enteredPassword);

    isLoading = false;
    if (!result) {
      _showSnackbar(context, TranslationEN.loginFailed);
    }
    return result;
  }

  void _showSnackbar(BuildContext context, String message) {
    if (context.findRenderObject() != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty || !value.contains('@')) {
      return TranslationEN.emailValidator;
    }

    return null;
  }

  String? validatePassword(String? value) {
    if ((value?.trim().length ?? 0) < 6) {
      return TranslationEN.passwordValidator;
    }

    return null;
  }

  void goToSignUpScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        Roots.signUpScreen, (Route<dynamic> route) => false);
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
