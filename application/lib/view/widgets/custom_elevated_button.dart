import 'package:application/utils/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
  });
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: Styles.startScreenButtonStyle,
      child: Text(
        text,
        style: Styles.startScreenButtonTextStyle,
      ),
    );
  }
}
