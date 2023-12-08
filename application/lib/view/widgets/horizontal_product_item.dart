import 'package:application/model/product_model.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/view/screens/product_screen.dart';
import 'package:flutter/material.dart';

class HorizontalProductItem extends StatelessWidget {
  final int number;
  final ProductModel productModel;

  const HorizontalProductItem({
    Key? key,
    required this.number,
    required this.productModel,
  }) : super(key: key);

  void navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          productModel: productModel,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: Styles.productBoxDecoration,
                  child: Text(
                    productModel.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${number + 1}',
                    style: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      productModel.product,
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      productModel.category,
                      style: const TextStyle(fontSize: 12.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
