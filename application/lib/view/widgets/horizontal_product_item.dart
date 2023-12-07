import 'package:application/utils/styles/styles.dart';
import 'package:application/view/screens/product_screen.dart';
import 'package:flutter/material.dart';

class HorizontalProductItem extends StatelessWidget {
  final int number;
  final String id;
  final String product;
  final String category;
  final String emoji;

  const HorizontalProductItem({
    Key? key,
    required this.number,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(7),
                decoration: Styles.productBoxDecoration,
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 15.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '${number + 1}',
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product,
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      category,
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
