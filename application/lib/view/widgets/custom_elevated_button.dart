import 'package:application/utils/colors.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    // this.textStyle,
    // this.style,
  });
  final VoidCallback onPressed;
  final String text;
  // final TextStyle? textStyle;
  // final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: Styles.startScreenButtonStyle,
      child: Text(
        text,
        // style: textStyle ?? Styles.startScreenButtonTextStyle,
        style: Styles.startScreenButtonTextStyle,
      ),
    );
  }
}
