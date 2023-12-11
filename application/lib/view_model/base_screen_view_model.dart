import 'package:application/view/screens/home_screen.dart';
import 'package:application/view/screens/offers_screen.dart';
import 'package:application/view/screens/products_screen.dart';
import 'package:application/view/screens/settings_screen.dart';
import 'package:application/view/widgets/custom_navigation_sheet_scaffold.dart';
import 'package:flutter/material.dart';

class BaseScreenViewModel extends ChangeNotifier {
  final List<Widget> pages = [
    const HomeScreen(),
    const ProductsScreen(),
    Container(),
    const OffersScreen(),
    const SettingsScreen(),
  ];
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void selectTab(int index, BuildContext context) {
    if (index == 2) {
      _openBottomSheet(context);
    } else {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void resetSelectedIndex() {
    _selectedIndex = 0;
    notifyListeners();
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const CustomNavigationSheet();
      },
    );
  }
}
