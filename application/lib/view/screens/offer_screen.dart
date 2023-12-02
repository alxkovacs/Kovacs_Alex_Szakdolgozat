import 'package:flutter/material.dart';

class OfferScreen extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String storeId;
  const OfferScreen({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
      ),
      body: const Center(
        child: Text('Product Screen'),
      ),
    );
  }
}
