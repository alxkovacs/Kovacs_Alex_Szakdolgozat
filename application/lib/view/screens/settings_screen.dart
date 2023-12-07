import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TranslationEN.settings),
      ),
      body: const Center(
        child: Text(TranslationEN.settings),
      ),
    );
  }
}
