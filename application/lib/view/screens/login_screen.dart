import 'package:application/utils/image_src.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view_model/login_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginScreenViewModel = Provider.of<LoginScreenViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            loginScreenViewModel.goToStartScreen(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: loginScreenViewModel.isLoading
            ? const CustomCircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthImageWidget(
                      imagePath: ImageSrc.loginScreenImage,
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  TranslationEN.login,
                                  style: Styles.signUpLoginStyle,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                decoration: AuthInputDecoration(
                                  labelText: TranslationEN.email,
                                  iconData: Icons.email_outlined,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) =>
                                    loginScreenViewModel.validateEmail(value),
                                onSaved: (value) {
                                  loginScreenViewModel.enteredEmail = value!;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                decoration: AuthInputDecoration(
                                  labelText: TranslationEN.password,
                                  iconData: Icons.lock_outline,
                                ),
                                obscureText: true,
                                validator: (value) => loginScreenViewModel
                                    .validatePassword(value),
                                onSaved: (value) {
                                  loginScreenViewModel.enteredPassword = value!;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: CustomElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    final success = await loginScreenViewModel
                                        .submitLogin(context);

                                    if (success && mounted) {
                                      loginScreenViewModel
                                          .goToBaseScreen(context);
                                    }
                                  }
                                },
                                text: TranslationEN.login,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                loginScreenViewModel.goToSignUpScreen(context);
                              },
                              child: const Text(
                                TranslationEN.goToSignUpScreen,
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
