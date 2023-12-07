import 'package:application/model/user_model.dart';
import 'package:application/service/authentication_service.dart';
import 'package:application/utils/roots.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/base_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreenViewModel extends ChangeNotifier {
  final UserModel _userModel = UserModel();
  final AuthenticationService _userService = AuthenticationService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set enteredFirstName(String value) {
    _userModel.firstName = value;
    notifyListeners();
  }

  set enteredEmail(String value) {
    _userModel.email = value;
    notifyListeners();
  }

  set enteredPassword(String value) {
    _userModel.password = value;
    notifyListeners();
  }

  Future<bool> submitSignUp(BuildContext context) async {
    isLoading = true;

    final result = await _userService.createUser(_userModel);

    isLoading = false;
    if (!result) {
      _showSnackbar(context, TranslationEN.registrationFailed);
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

  String? validateFirstName(String? value) {
    if ((value?.trim().length ?? 0) < 3) {
      return TranslationEN.firstNameValidator;
    }
    return null;
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
