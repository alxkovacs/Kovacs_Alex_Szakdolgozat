import 'package:application/utils/image_src.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view_model/sign_up_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final signUpScreenViewModel = Provider.of<SignUpScreenViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            signUpScreenViewModel.goToStartScreen(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: signUpScreenViewModel.isLoading
            ? const CustomCircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthImageWidget(
                      imagePath: ImageSrc.signUpScreenImage,
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                TranslationEN.signUp,
                                style: Styles.signUpLoginStyle,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: AuthInputDecoration(
                                labelText: TranslationEN.firstName,
                                iconData: Icons.person_2_outlined,
                              ),
                              validator: (value) => signUpScreenViewModel
                                  .validateFirstName(value),
                              onSaved: (value) {
                                signUpScreenViewModel.enteredFirstName = value!;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: AuthInputDecoration(
                                labelText: TranslationEN.email,
                                iconData: Icons.email_outlined,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) =>
                                  signUpScreenViewModel.validateEmail(value),
                              onSaved: (value) {
                                signUpScreenViewModel.enteredEmail = value!;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: AuthInputDecoration(
                                labelText: TranslationEN.password,
                                iconData: Icons.lock_outline,
                              ),
                              obscureText: true,
                              validator: (value) =>
                                  signUpScreenViewModel.validatePassword(value),
                              onSaved: (value) {
                                signUpScreenViewModel.enteredPassword = value!;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  final success = await signUpScreenViewModel
                                      .submitSignUp(context);

                                  if (success && mounted) {
                                    signUpScreenViewModel
                                        .goToBaseScreen(context);
                                  }
                                }
                              },
                              text: TranslationEN.signUp,
                            ),
                            const SizedBox(height: 5),
                            TextButton(
                              onPressed: () {
                                signUpScreenViewModel.goToLogInScreen(context);
                              },
                              child: const Text(
                                TranslationEN.goToLogInScreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
