import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, Alex'),
        actions: [
          IconButton(
              onPressed: () {
                _firebase.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'start', (Route<dynamic> route) => false);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: const Center(
        child: Text('Sikeresen bejelentkeztél!'),
      ),
    );
  }
}
