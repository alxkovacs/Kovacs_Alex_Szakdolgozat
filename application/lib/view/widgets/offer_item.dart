import 'package:application/view/widgets/offer_item_base.dart';
import 'package:flutter/material.dart';

class OfferItem extends OfferItemBase {
  const OfferItem({
    Key? key,
    required String title,
    required String emoji,
    required double width,
    required double fontSize,
  }) : super(
          key: key,
          title: title,
          emoji: emoji,
          width: width,
          fontSize: fontSize,
        );
}
