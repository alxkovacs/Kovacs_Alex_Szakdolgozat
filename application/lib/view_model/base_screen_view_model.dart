import 'package:application/utils/colors.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/add_product_screen.dart';
import 'package:flutter/material.dart';

class BaseScreenViewModel extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void selectTab(int index, BuildContext context) {
    if (index == 2) {
      _openBottomSheet(context);
    } else {
      _selectedIndex = index;
      notifyListeners(); // Ez a sor biztosítja, hogy a UI frissüljön az állapotváltozás után
    }
  }

  void _openBottomSheet(BuildContext context) {
    // Bottom Sheet megnyitásának logikája
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 35.0),
          child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: const Text(
                TranslationEN.addProduct,
                style: Styles.screenCenterTitle,
              ),
              leading: IconButton(
                icon: const Icon(Icons.close), // "X" ikon
                onPressed: () =>
                    Navigator.pop(context), // Bezárja a ModalBottomSheet-t
              ),
            ),
            // Itt állíthatod be a Scaffold háttérszínét, ha szükséges
            backgroundColor: AppColor.lightBackgroundColor,
            body: const AddProductScreen(),
          ),
        );
      },
    );
  }
}
