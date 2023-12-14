import 'package:application/utils/translation_en.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/view/widgets/offers_horizontal_list.dart';
import 'package:application/view_model/offers_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        Provider.of<OffersScreenViewModel>(context, listen: false).fetchData());
  }

  @override
  Widget build(BuildContext context) {
    final offersScreenViewModel = Provider.of<OffersScreenViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          TranslationEN.myOffers,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
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
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: OffersHorizontalList(
                offers: offersScreenViewModel.offers,
                isSmallSizeRequired: false,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  TranslationEN.mostViewedOffers,
                  style: Styles.offersScreenHorizontalListSubtitle,
                ),
              ),
            ),
            OffersHorizontalList(
              offers: offersScreenViewModel.mostViewedOffers,
              isSmallSizeRequired: true,
            )
          ],
        ),
      ),
    );
  }
}
