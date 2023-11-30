import 'package:application/providers/sign_up_view_model_provider.dart';
import 'package:application/utils/image_src.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredFirstName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(signUpViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            viewModel.goToStartScreen(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: viewModel.isLoading
            ? const CustomCircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthImageWidget(
                      imagePath: ImageSrc.signUpScreenImage,
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(30), // 24 volt
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
                                validator: (value) =>
                                    viewModel.validateFirstName(value),
                                onSaved: (value) {
                                  _enteredFirstName = value!;
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
                                    viewModel.validateEmail(value),
                                onSaved: (value) {
                                  _enteredEmail = value!;
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
                                    viewModel.validatePassword(value),
                                onSaved: (value) {
                                  _enteredPassword = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    final success =
                                        await viewModel.submitSignUp(
                                      _enteredFirstName,
                                      _enteredEmail,
                                      _enteredPassword,
                                      context,
                                      ref,
                                    );

                                    if (success && mounted) {
                                      viewModel.goToBaseScreen(context);
                                    }
                                  }
                                },
                                text: TranslationEN.signUp,
                              ),
                              const SizedBox(height: 5),
                              TextButton(
                                onPressed: () {
                                  viewModel.goToLogInScreen(context);
                                },
                                child: const Text(
                                  TranslationEN.goToLogInScreen,
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
