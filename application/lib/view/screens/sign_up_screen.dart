import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Regisztráció"),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(57, 255, 20, 1),
      ),
      body: const Center(
        child: Text('Welcome to the Registration Page!'),
      ),
    );
  }
}
