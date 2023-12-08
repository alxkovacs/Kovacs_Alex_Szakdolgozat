import 'package:application/model/product_model.dart';
import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final ProductModel productModel;

  const ProductScreen({
    Key? key,
    required this.productModel,
  }) : super(key: key);

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
