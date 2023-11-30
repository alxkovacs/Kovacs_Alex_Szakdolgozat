import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredPassword = '';

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(TranslationEN.login),
      ),
      body: const Center(
        child: Text(TranslationEN.login),
      ),
    );
  }
}
