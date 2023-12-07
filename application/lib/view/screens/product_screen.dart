import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final String id;
  final String product;
  final String category;
  final String emoji;

  const ProductScreen({
    super.key,
    required this.id,
    required this.product,
    required this.category,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TranslationEN.product),
      ),
      body: const Center(
        child: Text(TranslationEN.product),
      ),
    );
  }
}
