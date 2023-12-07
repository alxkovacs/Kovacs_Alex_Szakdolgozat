import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TranslationEN.shoppingList),
      ),
      body: const Center(
        child: Text(TranslationEN.shoppingList),
      ),
    );
  }
}
