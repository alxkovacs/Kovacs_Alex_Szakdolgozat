import 'package:application/utils/styles/styles.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/sign_up_view_model.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

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

  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    //Todo
    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enteredEmail);
      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'email-already-in-use') {
        // ...
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.message ?? 'Sikertelen regisztráció!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Regisztráció"),
        // foregroundColor: Colors.white,
        // backgroundColor: const Color.fromRGBO(57, 255, 20, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                'start', (Route<dynamic> route) => false);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 400,
                child: Image.asset('assets/images/sign_up_screen_image.png'),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32),
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
                              fontSize: 36,
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
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: AuthInputDecoration(
                            labelText: 'Jelszó',
                            iconData: Icons.lock_outline,
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'A jelszónak legalább 6 karakter hosszúnak kell lennie.';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        const SizedBox(height: 30),
                        CustomElevatedButton(
                          onPressed: _submit,
                          text: 'Regisztráció',
                          // ... és így tovább, bármilyen más paraméterrel, amelyet át szeretne adni
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle navigation to sign in screen.
                            viewModel.goToNextScreen(context);
                          },
                          child: const Text(
                            'Ha már regisztráltál, akkor jelentkezz be itt',
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
