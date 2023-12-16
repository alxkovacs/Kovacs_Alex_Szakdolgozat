import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int newValue) {
    _selectedIndex = newValue;
    notifyListeners();
  }

  void resetSelectedIndex() {
    selectedIndex = 0;
  }
}
