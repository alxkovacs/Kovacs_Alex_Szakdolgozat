import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/favorites_screen.dart';
import 'package:application/view/screens/shopping_list_screen.dart';
import 'package:flutter/material.dart';

class HomeScreenViewModel extends ChangeNotifier {
  String userFirstName = 'Ismeretlen';
  List<Map<String, dynamic>> menu = [
    {
      'name': TranslationEN.shoppingList,
      'goToPage': () => const ShoppingListScreen(),
    },
    {
      'name': TranslationEN.favorites,
      'goToPage': () => const FavoritesScreen(),
    },
  ];

  void fetchData() {
    // Itt történik a felhasználónév és egyéb adatok lekérése
    userFirstName = 'Minta Név'; // Példa adat
    notifyListeners();
  }

  // További metódusok és logika
}
