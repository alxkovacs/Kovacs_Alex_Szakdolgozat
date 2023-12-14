import 'package:application/utils/colors.dart';
import 'package:flutter/material.dart';

abstract class OfferItemBase extends StatelessWidget {
  const OfferItemBase({
    Key? key,
    required this.title,
    required this.emoji,
    required this.width,
    required this.fontSize,
  }) : super(key: key);

  final String title;

  final String emoji;
  final double width;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        color: AppColor.mainColor.withOpacity(width == 150.0 ? 0.10 : 0.25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ),
      ),
    );
  }
}
