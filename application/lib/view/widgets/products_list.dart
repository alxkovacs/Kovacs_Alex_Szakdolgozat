import 'package:application/model/product_model.dart';
import 'package:application/view/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductsList extends StatelessWidget {
  final List<ProductModel> products;

  const ProductsList({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final productModel = products[index];
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: ProductCard(
            productModel: productModel,
          ),
        );
      },
    );
  }
}
