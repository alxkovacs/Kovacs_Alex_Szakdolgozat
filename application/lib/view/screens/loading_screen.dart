import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TranslationEN.home),
      ),
      body: const Center(
        child: Text('${TranslationEN.loading}...'),
      ),
    );
  }
}
