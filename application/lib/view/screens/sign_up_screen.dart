import 'package:application/utils/styles/styles.dart';
import 'package:application/view_model/sign_up_view_model.dart';
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
                  padding: EdgeInsets.all(32),
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
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(67, 153, 182, 0.5),
                            labelText: 'Keresztnév', // A címke szövege
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.black),
                            suffixIcon: const Icon(
                              Icons.person_2_outlined,
                              color: Colors.black,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 20), // Az űrlapmező belső margója
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Az űrlapmező sarkainak lekerekítése
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(67, 153, 182, 1.0),
                              ), // Az űrlapmező keretének színe
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(67, 153, 182, 1.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Az űrlapmező sarkainak lekerekítése, amikor fókuszban van
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(67, 153, 182, 1.0),
                              ), // Az űrlapmező keretének színe, amikor fókuszban van
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(67, 153, 182, 0.5),
                            labelText: 'E-mail', // A címke szövege
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.black),
                            suffixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 20), // Az űrlapmező belső margója
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Az űrlapmező sarkainak lekerekítése
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(67, 153, 182, 1.0),
                              ), // Az űrlapmező keretének színe
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(67, 153, 182, 1.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Az űrlapmező sarkainak lekerekítése, amikor fókuszban van
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(67, 153, 182, 1.0),
                              ), // Az űrlapmező keretének színe, amikor fókuszban van
                            ),
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
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(67, 153, 182, 0.5),
                            labelText: 'Jelszó', // A címke szövege
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.black),
                            suffixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 20), // Az űrlapmező belső margója
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Az űrlapmező sarkainak lekerekítése
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(67, 153, 182, 1.0),
                              ), // Az űrlapmező keretének színe
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(67, 153, 182, 1.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Az űrlapmező sarkainak lekerekítése, amikor fókuszban van
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(67, 153, 182, 1.0),
                              ), // Az űrlapmező keretének színe, amikor fókuszban van
                            ),
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
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submit,
                          style: Styles.startScreenButtonStyle,
                          child: const Text(
                            'Regisztráció',
                            style: TextStyle(
                              color: Colors.white, // A gomb szövegének színe
                              fontSize: 16, // A gomb szövegének mérete
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle navigation to sign in screen.
                            viewModel.goToNextScreen(context);
                          },
                          child: const Text(
                              'Ha már regisztráltál, akkor jelentkezz be itt'),
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
