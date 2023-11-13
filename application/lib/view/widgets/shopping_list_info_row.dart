import 'package:flutter/material.dart';

class ShoppingListInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const ShoppingListInfoRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0), // Alsó térköz
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: const Color.fromRGBO(67, 153, 182, 1), // Szöveg színe
              fontWeight: FontWeight.w500, fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
