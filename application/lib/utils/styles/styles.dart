import 'package:application/utils/styles/utils.dart';
import 'package:flutter/material.dart';

class Styles {
  static final String valamiFont = 'Trajan Pro';
  static final String masikFont = 'Schyler';

  static final TextStyle headerStyles = TextStyle(
    fontFamily: valamiFont,
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
    backgroundColor:
        Color.fromRGBO(67, 153, 182, 1.0), // Gombon lévő szöveg színe
    shadowColor: Colors.blue[200], // Árnyék színe
    elevation: 5, // Árnyék mélysége
    padding: const EdgeInsets.symmetric(
        horizontal: 100, vertical: 15), // Padding a gomb körül
    shape: RoundedRectangleBorder(
      // Kerekített szélű gomb
      borderRadius: BorderRadius.circular(30), // Szögletek kerekítése
    ),
  );

  static final startScreenButtonTextStyle = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
}
