import 'package:application/model/offer_model.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/offer_screen.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/offer_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OffersHorizontalList extends StatelessWidget {
  const OffersHorizontalList({super.key});

  Future<List<OfferModel>> fetchOffers() async {
    return FirebaseFirestore.instance
        .collection('offers')
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => OfferModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OfferModel>>(
      future: fetchOffers(),
      builder:
          (BuildContext context, AsyncSnapshot<List<OfferModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomCircularProgressIndicator(); // Show a loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Text('${TranslationEN.error}: ${snapshot.error}');
        } else {
          // Data is fetched successfully, build your UI here
          return Container(
            // Itt hiányzott a return
            color: Colors.transparent,
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data?.length ??
                  0, // Itt használhatod a snapshot.data-t
              itemBuilder: (context, index) {
                final offer = snapshot.data![index];
                // A padding most az elem bal oldalán lesz, kivéve az első elemet
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 10.0 : 0,
                    right:
                        10.0, // Minden elem után 15.0 logikai pixel a távolság
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OfferScreen(
                            id: offer.id,
                            name: offer.name,
                            description: offer.description,
                            emoji: offer.emoji,
                            storeId: offer.storeId,
                          ),
                        ),
                      );
                    },
                    child: OfferItem(
                      title: offer.name,
                      emoji: offer.emoji,
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
