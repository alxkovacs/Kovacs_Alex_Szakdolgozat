import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String id;
  final String storeName;
  final String postcode;
  final String city;
  final String address;

  Store({
    required this.id,
    required this.storeName,
    required this.postcode,
    required this.city,
    required this.address,
  });

  // Egy metódus az adatbázisból lekért adatok modellé alakítására
  factory Store.fromFirestore(DocumentSnapshot doc) {
    return Store(
      id: doc.id,
      storeName: doc['storeName'],
      postcode: doc['postcode'],
      city: doc['city'],
      address: doc['address'],
    );
  }
}
