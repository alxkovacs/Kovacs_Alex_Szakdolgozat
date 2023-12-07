import 'package:application/model/product_model.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/view_model/products_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final productsScreenviewModel =
        Provider.of<ProductsScreenViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () => productsScreenviewModel.navigateToDetails(
        context,
        ProductModel(
            id: id, product: product, category: category, emoji: emoji),
      ),
      child: Card(
        color: Colors.white,
        elevation: 0.0,
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(11),
            decoration: Styles.productBoxDecoration,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
          title: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
