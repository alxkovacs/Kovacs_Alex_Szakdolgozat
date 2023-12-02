import 'package:flutter/material.dart';

class DescriptionTab extends StatelessWidget {
  final String description;

  const DescriptionTab(this.description, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
