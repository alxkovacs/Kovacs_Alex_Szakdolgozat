import 'package:application/view/widgets/offer_item_base.dart';
import 'package:flutter/material.dart';

class OfferItem extends OfferItemBase {
  const OfferItem({
    Key? key,
    required String title,
    required String emoji,
  }) : super(
          key: key,
          title: title,
          emoji: emoji,
          width: 300.0,
          fontSize: 60.0,
        );
}
