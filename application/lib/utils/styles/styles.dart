import 'package:application/utils/colors.dart';
import 'package:application/utils/styles/utils.dart';
import 'package:flutter/material.dart';

class Styles {
  static const String trojanFont = 'Trajan Pro';
  static const String schylerFont = 'Schyler';

  static const homeScreenHorizontalListTitle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  static BoxDecoration productBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: AppColor.lightBackgroundColor, // Zöld háttér beállítása.
    shape: BoxShape.rectangle, // Kerek forma a konténernek.
    boxShadow: [
      BoxShadow(
        color: AppColor.mainColor.withOpacity(0.5),
        blurRadius: 10.0,
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

  static BoxDecoration boxDecorationWithShadow = BoxDecoration(
    color: AppColor.lightBackgroundColor, // Háttérszín beállítása
    borderRadius: BorderRadius.circular(15.0), // Keret lekerekítése
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
    backgroundColor: const Color.fromRGBO(67, 153, 182, 1.0),
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
