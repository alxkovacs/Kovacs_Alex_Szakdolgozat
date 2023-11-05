import 'package:flutter/material.dart';

class AuthImageWidget extends StatelessWidget {
  final String imagePath;

  const AuthImageWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 30,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      width: 400,
      child: Image.asset(imagePath),
    );
  }
}
