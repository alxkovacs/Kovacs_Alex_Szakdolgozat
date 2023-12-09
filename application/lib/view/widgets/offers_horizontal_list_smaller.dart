import 'package:application/model/offer_model.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/offer_screen.dart';
import 'package:application/view/widgets/offer_item_smaller.dart';
import 'package:flutter/material.dart';

class OffersHorizontalListSmaller extends StatelessWidget {
  final List<OfferModel> offers;

  const OffersHorizontalListSmaller({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return const Text(TranslationEN.noOffersAvailable);
    }

    return Container(
      color: Colors.transparent,
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offerModel = offers[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 10.0 : 0,
              right: 10.0,
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OfferScreen(
                      offerModel: offerModel,
                    ),
                  ),
                );
              },
              child: OfferItemSmaller(
                title: offerModel.name,
                emoji: offerModel.emoji,
              ),
            ),
          );
        },
      ),
    );
  }
}
