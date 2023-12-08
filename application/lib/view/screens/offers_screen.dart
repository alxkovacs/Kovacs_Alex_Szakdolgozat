import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TranslationEN.offers),
      ),
      body: const Center(
        child: Text(TranslationEN.offers),
      ),
    );
  }
}
