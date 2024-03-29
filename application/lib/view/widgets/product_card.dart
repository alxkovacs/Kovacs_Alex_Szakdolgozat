import 'package:application/model/product_model.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/view/screens/product_screen.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel productModel;

  const ProductCard({
    Key? key,
    required this.productModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductScreen(
            productModel: productModel,
          ),
        ),
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
              productModel.emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          title: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            productModel.product,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Text(
            productModel.category,
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
