import 'package:application/utils/image_src.dart';
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
              ImageSrc.homeScreenSquareImage,
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 40, right: 40, bottom: 50),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double buttonWidth =
                          constraints.maxWidth > 600 ? 500 : double.infinity;

                      return Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: buttonWidth,
                          child: CustomElevatedButton(
                            onPressed: () {
                              viewModel.goToNextScreen(context);
                            },
                            text: TranslationEN.continueButton,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
