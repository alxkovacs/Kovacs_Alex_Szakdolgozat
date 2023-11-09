import 'package:application/utils/colors.dart';
import 'package:application/view/screens/base_screen.dart';
import 'package:application/view/screens/home_screen.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/login_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() {
    return _LogInScreenState();
  }
}

class _LogInScreenState extends State<LogInScreen> {
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
      if (err.code == 'email-already-in-use') {
        // ...
      }
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
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Bejelentkezés"),
    //     // foregroundColor: Colors.white,
    //     // backgroundColor: const Color.fromRGBO(57, 255, 20, 1),
    //     leading: IconButton(
    //       onPressed: () {
    //         Navigator.of(context).pushNamedAndRemoveUntil(
    //             'start', (Route<dynamic> route) => false);
    //       },
    //       icon: const Icon(Icons.arrow_back),
    //     ),
    //   ),
    //   body: Center(
    //     child: SingleChildScrollView(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Container(
    //             margin: const EdgeInsets.only(
    //               top: 30,
    //               bottom: 20,
    //               left: 20,
    //               right: 20,
    //             ),
    //             width: 400,
    //             child: Image.asset('assets/images/sign_up_screen_image.png'),
    //           ),
    //           Card(
    //             margin: const EdgeInsets.all(20),
    //             child: SingleChildScrollView(
    //               child: Padding(
    //                 padding: EdgeInsets.all(16),
    //                 child: Form(
    //                   key: _form,
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       TextFormField(
    //                         decoration:
    //                             const InputDecoration(labelText: 'E-mail'),
    //                         keyboardType: TextInputType.emailAddress,
    //                         autocorrect: false,
    //                         textCapitalization: TextCapitalization.none,
    //                         validator: (value) {
    //                           if (value == null ||
    //                               value.trim().isEmpty ||
    //                               !value.contains('@')) {
    //                             return 'Kérlek egy létező e-mail címet adj meg';
    //                           }

    //                           return null;
    //                         },
    //                         onSaved: (value) {
    //                           _enteredEmail = value!;
    //                         },
    //                       ),
    //                       TextFormField(
    //                         decoration:
    //                             const InputDecoration(labelText: 'Jelszó'),
    //                         obscureText: true,
    //                         validator: (value) {
    //                           if (value == null || value.trim().length < 6) {
    //                             return 'A jelszónak legalább 6 karakter hosszúnak kell lennie.';
    //                           }

    //                           return null;
    //                         },
    //                         onSaved: (value) {
    //                           _enteredPassword = value!;
    //                         },
    //                       ),
    //                       const SizedBox(
    //                         height: 12,
    //                       ),
    //                       ElevatedButton(
    //                         onPressed: _submit,
    //                         child: const Text('Bejelentkezés'),
    //                       ),
    //                       TextButton(
    //                         onPressed: () {
    //                           // Handle navigation to sign in screen.
    //                           viewModel.goToNextScreen(context);
    //                         },
    //                         child:
    //                             const Text('Még nincs fiókod? Regisztrálj itt'),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

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
