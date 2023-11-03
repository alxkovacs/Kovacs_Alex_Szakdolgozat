import 'package:application/utils/styles/styles.dart';
import 'package:application/view_model/start_screen_view_model.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StartScreenViewModel viewModel = StartScreenViewModel();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/start_screen_image.png',
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
                ElevatedButton(
                  onPressed: () {
                    viewModel.goToNextScreen();
                  },
                  style: Styles.startScreenButtonStyle,
                  child: Text(
                    'Kezdjünk neki',
                    style: Styles.startScreenButtonTextStyle,
                  ),
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
