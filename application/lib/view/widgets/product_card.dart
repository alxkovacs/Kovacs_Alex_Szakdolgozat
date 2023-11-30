import 'package:application/utils/styles/styles.dart';
import 'package:application/view/screens/product_screen.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String product;
  final String category;
  final String emoji;

  const ProductCard({
    Key? key,
    required this.id,
    required this.product,
    required this.category,
    required this.emoji,
  }) : super(key: key);

  void navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          id: id,
          product: product,
          category: category,
          emoji: emoji,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToDetails(context),
      child: Card(
        color: Colors.white,
        elevation: 0.0,
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(
                11), // A padding beállítása az emoji körül.
            decoration: Styles.productBoxDecoration,
            child: Text(
              emoji, // Itt helyezze el az emojit.
              style:
                  const TextStyle(fontSize: 24), // Emoji méretének beállítása.
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 0.0), // Állítsd be a ListTile paddingját
          title: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Több sor esetén pontokkal zárul
            product,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Text(
            category,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        ),
      ),
    );
  }
}
