import 'package:application/model/product_model.dart';
import 'package:application/view/widgets/horizontal_product_item.dart';
import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<ProductModel> products;

  const HorizontalList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 220,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          childAspectRatio: 0.195,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              left: index < 3 ? 0 : 0,
              right: index > 5 ? 10 : 0,
            ),
            child: HorizontalProductItem(
              number: index,
              id: products[index].id,
              product: products[index].product,
              category: products[index].category,
              emoji: products[index].emoji,
            ),
          );
        },
      ),
    );
  }
}
