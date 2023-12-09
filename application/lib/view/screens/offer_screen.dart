import 'package:application/model/offer_model.dart';
import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';

class OfferScreen extends StatelessWidget {
  final OfferModel offerModel;

  const OfferScreen({
    Key? key,
    required this.offerModel,
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
