import 'package:application/utils/translation_en.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/offers_horizontal_list.dart';
import 'package:application/view/widgets/offers_horizontal_list_smaller.dart';
import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          TranslationEN.myOffers,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      TranslationEN.specialOffers,
                      style: Styles.offersScreenHorizontalListSubtitle,
                    ),
                  ),
                ],
              ),
            ),
            OffersHorizontalList(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  TranslationEN.mostViewedOffers,
                  style: Styles.offersScreenHorizontalListSubtitle,
                ),
              ),
            ),
            OffersHorizontalListSmaller(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
