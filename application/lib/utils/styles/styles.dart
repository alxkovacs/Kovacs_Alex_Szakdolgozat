import 'package:application/utils/styles/utils.dart';
import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';

class Styles {
  static const String trojanFont = 'Trajan Pro';
  static const String schylerFont = 'Schyler';

  static const TextStyle favoritesScreenSubtitle =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  static const TextStyle favoritesScreenTitle =
      TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

  static const TextStyle shoppingListSubtitle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const TextStyle shoppingListPrice =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  static TextStyle shoppingListStoreName = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: Colors.black.withOpacity(0.65),
  );

  static const offersScreenHorizontalListSubtitle = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 22, color: AppColor.mainColor);

  static const homeScreenHorizontalListTitle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  static InputDecoration storeSearchDecoration = InputDecoration(
    isDense: true, // Added this
    contentPadding: const EdgeInsets.all(0),
    hintText: TranslationEN.searchBetweenStores,
    hintStyle: TextStyle(color: AppColor.mainColor.withOpacity(0.75)),
    filled: true, // Ez engedélyezi a háttérszín beállítását
    fillColor: AppColor.mainColor
        .withOpacity(0.20), // A háttérszín beállítása kék színre
    prefixIcon: const Icon(
      Icons.search,
      color: AppColor.mainColor,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: AppColor.mainColor.withOpacity(0.15),
      ), // A szegély színe piros
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: AppColor.mainColor.withOpacity(0.15),
      ), // A szegély színe piros
    ),
    // Beállítja a fókuszált szegély színét is pirosra
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: AppColor.mainColor.withOpacity(0.15),
      ),
    ),
  );

  static BoxDecoration favoriteProductBoxDecoration = BoxDecoration(
    color: Colors.white, // Háttérszín beállítása
    borderRadius: BorderRadius.circular(30.0), // Keret lekerekítése
    boxShadow: [
      BoxShadow(
        color: AppColor.mainColor.withOpacity(0.5),
        offset: const Offset(
          5.0,
          5.0,
        ),
        blurRadius: 15.0,
        spreadRadius: 1.0,
      ), //BoxShadow
      const BoxShadow(
        color: Colors.white,
        offset: Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 0.0,
      ), //BoxShadow
    ],
  );

  static const homeScreenButtons = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static BoxDecoration productBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: AppColor.lightBackgroundColor,
    shape: BoxShape.rectangle,
    boxShadow: [
      BoxShadow(
        color: AppColor.mainColor.withOpacity(0.5),
        blurRadius: 10.0,
        spreadRadius: 1.0,
      ),
      const BoxShadow(
        color: Colors.white,
        offset: Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 0.0,
      ),
    ],
  );

  static BoxDecoration boxDecorationWithShadow = BoxDecoration(
    color: AppColor.lightBackgroundColor,
    borderRadius: BorderRadius.circular(15.0),
    boxShadow: [
      BoxShadow(
        color: AppColor.mainColor.withOpacity(0.5),
        offset: const Offset(5.0, 5.0),
        blurRadius: 10.0,
        spreadRadius: 1.0,
      ),
      const BoxShadow(
        color: Colors.white,
        offset: Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 0.0,
      ),
    ],
  );

  static const screenCenterTitle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 22);

  static const signUpLoginStyle = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.bold,
  );

  static const headerStyle = TextStyle(
    color: Colors.black,
    fontSize: 48,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headerStyles = TextStyle(
    fontFamily: trojanFont,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.black87,
  );

  static final bodyStyle = extend(
    headerStyles,
    const TextStyle(
      fontSize: 40,
      decoration: TextDecoration.underline,
    ),
  );

  static final startScreenButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: AppColor.mainColor,
    shadowColor: Colors.blue[200],
    elevation: 5,
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static const startScreenButtonTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}
