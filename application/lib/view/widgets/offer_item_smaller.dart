import 'package:application/view/widgets/offer_item_base.dart';
import 'package:flutter/material.dart';

class OfferItemSmaller extends OfferItemBase {
  const OfferItemSmaller({
    Key? key,
    required String title,
    required String emoji,
  }) : super(
          key: key,
          title: title,
          emoji: emoji,
          width: 150.0,
          fontSize: 30.0,
        );
}
