import 'package:application/utils/colors.dart';
import 'package:flutter/material.dart';

class AuthInputDecoration extends InputDecoration {
  final String labelText;
  final IconData iconData;

  AuthInputDecoration({
    required this.labelText,
    required this.iconData,
    // A Theme.of(context) nem használható itt közvetlenül, mivel ez nem egy widget.
    // A színek és a text style paraméterekként kerülnek átadásra.
    Color fillColor = AppColor.authInputDecorationFillColor,
    Color borderColor = AppColor.mainColor,
  }) : super(
          filled: true,
          fillColor: fillColor,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
          ),
          suffixIcon: Icon(
            iconData,
            color: Colors.black,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
        );
}
