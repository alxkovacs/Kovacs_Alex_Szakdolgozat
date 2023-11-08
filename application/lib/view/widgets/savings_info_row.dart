import 'package:flutter/material.dart';

class SavingsInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const SavingsInfoRow({
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
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: const Color.fromRGBO(67, 153, 182, 1), // Szöveg színe
              fontWeight: FontWeight.bold, fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
