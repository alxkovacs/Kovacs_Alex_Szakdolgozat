import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TranslationEN.products),
      ),
      body: const Center(
        child: Text(TranslationEN.products),
      ),
    );
  }
}
