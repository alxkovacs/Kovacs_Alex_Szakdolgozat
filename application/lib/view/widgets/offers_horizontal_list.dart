import 'package:application/model/offer.dart';
import 'package:application/view/screens/offer_screen.dart';
import 'package:application/view/widgets/offer_item.dart';
import 'package:application/view/widgets/product_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OffersHorizontalList extends StatelessWidget {
  OffersHorizontalList({super.key});

  Future<List<Offer>> fetchOffers() async {
    // Your database fetching logic goes here
    // For example, fetching from Firebase Firestore would look something like this:
    return FirebaseFirestore.instance
        .collection('offers')
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs.map((doc) => Offer.fromFirestore(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Offer>>(
      future: fetchOffers(),
      builder: (BuildContext context, AsyncSnapshot<List<Offer>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
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
                      number: index,
                      title: offer.name,
                      store: offer.storeId,
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
