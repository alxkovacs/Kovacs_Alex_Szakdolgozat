import 'package:application/utils/styles/styles.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/start_view_model.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StartViewModel viewModel = StartViewModel();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/start_screen_image.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Valami izgi név.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 300),
                CustomElevatedButton(
                  onPressed: () {
                    viewModel.goToNextScreen(context);
                  },
                  text: 'Kezdjünk neki',
                ),
                const SizedBox(height: 50)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
