import 'package:application/utils/colors.dart';
import 'package:application/view/screens/base_screen.dart';
import 'package:application/view/screens/home_screen.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/sign_up_view_model.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpViewModel viewModel = SignUpViewModel();
  final _form = GlobalKey<FormState>();

  bool _isLoading = false;

  var _enteredFirstName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                'start', (Route<dynamic> route) => false);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.mainColor),
              ) // Töltés ikon megjelenítése
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthImageWidget(
                      imagePath: 'assets/images/sign_up_screen_image.png',
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(30), // 24 volt
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Regisztráció',
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: AuthInputDecoration(
                                  labelText: 'Keresztnév',
                                  iconData: Icons.person_2_outlined,
                                ),
                                // textCapitalization: TextCapitalization.,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 3) {
                                    return 'A névnek legalább 3 karakter hosszúnak kell lennie.';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredFirstName = value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: AuthInputDecoration(
                                  labelText: 'E-mail',
                                  iconData: Icons.email_outlined,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains('@')) {
                                    return 'Kérlek egy létező e-mail címet adj meg';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredEmail = value!;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                decoration: AuthInputDecoration(
                                  labelText: 'Jelszó',
                                  iconData: Icons.lock_outline,
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 6) {
                                    return 'A jelszónak legalább 6 karakter hosszúnak kell lennie.';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPassword = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomElevatedButton(
                                onPressed: () async {
                                  if (_form.currentState!.validate()) {
                                    setState(() => _isLoading = true);
                                    _form.currentState!.save();
                                    bool success = await viewModel.submitSignUp(
                                      _enteredFirstName,
                                      _enteredEmail,
                                      _enteredPassword,
                                    );
                                    // await Future.delayed(
                                    //     const Duration(milliseconds: 100));
                                    // setState(() => _isLoading = false);

                                    if (success) {
                                      if (mounted) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                const BaseScreen(),
                                            transitionDuration: Duration.zero,
                                          ),
                                          (Route<dynamic> route) => false,
                                        );
                                        Navigator.of(context).pushReplacement(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                const BaseScreen(),
                                            transitionDuration:
                                                const Duration(seconds: 0),
                                          ),
                                        );
                                      }
                                    } else {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Sikertelen regisztráció!'),
                                          ),
                                        );
                                      }
                                    }
                                    await Future.delayed(
                                      const Duration(milliseconds: 100),
                                    );
                                    if (mounted) {
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                },
                                text: 'Regisztráció',
                              ),
                              const SizedBox(height: 5),
                              TextButton(
                                onPressed: () {
                                  viewModel.goToNextScreen(context);
                                },
                                child: const Text(
                                  'Ha már van fiókja, jelentkezzen be itt.',
                                ),
                              ),
                            ],
                          ),
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
