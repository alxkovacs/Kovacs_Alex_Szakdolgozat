import 'package:application/utils/colors.dart';
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
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16 * textScaleFactor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColor.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 15 * textScaleFactor,
            ),
          ),
        ],
      ),
    );
  }
}
