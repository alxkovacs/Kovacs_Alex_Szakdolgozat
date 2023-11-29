import 'package:application/utils/image_src.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
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
          Positioned.fill(
            child: Image.asset(
              ImageSrc.startScreenImage,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 300),
                  child: Text(
                    TranslationEN.applicationName,
                    style: Styles.headerStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: CustomElevatedButton(
                    onPressed: () {
                      viewModel.goToNextScreen(context);
                    },
                    text: TranslationEN.continueButton,
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
