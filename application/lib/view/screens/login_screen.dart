import 'package:application/utils/colors.dart';
import 'package:application/view/screens/base_screen.dart';
import 'package:application/view/screens/home_screen.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/login_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _firebase = FirebaseAuth.instance;

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() {
    return _LogInScreenState();
  }
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  LogInViewModel viewModel = LogInViewModel();
  final _form = GlobalKey<FormState>();

  bool _isLoading = false;

  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    try {
      final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
      if (context.mounted) {
        // Navigator.pushNamed(context, 'start');
        Navigator.of(context)
            .pushNamedAndRemoveUntil('base', (Route<dynamic> route) => false);
      }
    } on FirebaseAuthException catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.message ?? 'Sikertelen bejelentkezés!'),
          ),
        );
      }
    }
  }

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
                      imagePath: 'assets/images/login_screen_image.png',
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
                                  'Bejelentkezés',
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
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
                                    bool success = await viewModel.submitLogIn(
                                      _enteredEmail,
                                      _enteredPassword,
                                      ref,
                                    );

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
                                text: 'Bejelentkezés',
                              ),
                              const SizedBox(height: 5),
                              TextButton(
                                onPressed: () {
                                  viewModel.goToNextScreen(context);
                                },
                                child: const Text(
                                  'Még nem regisztrált? Hozzon létre egy fiókot itt.',
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
