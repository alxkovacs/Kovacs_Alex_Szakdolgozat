import 'package:flutter/material.dart';

class StoreName extends StatelessWidget {
  final String storeName;

  const StoreName({Key? key, required this.storeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          storeName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
