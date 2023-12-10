import 'package:application/model/product_model.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/view/screens/product_screen.dart';
import 'package:flutter/material.dart';

class FavoriteItemCard extends StatelessWidget {
  final ProductModel productModel;

  const FavoriteItemCard({
    Key? key,
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
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
          right: 10,
          left: 10,
          top: 10,
        ),
        decoration: Styles.favoriteProductBoxDecoration,
        child: Card(
          shadowColor: Colors.transparent,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 0.0,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 0,
              right: 10,
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      productModel.emoji,
                      style: const TextStyle(
                        fontSize: 70.0,
                      ),
                    ),
                  ),
                ),
                Text(
                  productModel.product,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  productModel.category,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
