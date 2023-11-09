import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view/widgets/horizontal_list.dart';
import 'package:application/view/widgets/savings_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'Hello, Alex',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28),
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const AuthImageWidget(
                imagePath: 'assets/images/home_screen_image.png',
              ),
              const SavingsCard(),
              const SizedBox(height: 15),
              CustomElevatedButton(
                onPressed: () {},
                text: 'Bevásárlólista',
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Legtöbbet megtekintett termékek',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              HorizontalList(),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Neked ajánlott termékek',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              HorizontalList(),
            ],
          ),
        ),
      ),
    );
  }
}
