import 'package:application/model/price_and_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final priceAndStoreProvider =
    StreamProvider.family<List<PriceAndStore>, String>((ref, String productId) {
  // A stream lekérdezése, ami figyeli az adott termékhez tartozó árakat
  return FirebaseFirestore.instance
      .collection('productPrice')
      .where('productID', isEqualTo: productId)
      .snapshots()
      .asyncMap((snapshot) async {
    List<PriceAndStore> priceAndStoreList = [];

    // Minden egyes ár adatainak lekérdezése
    for (var priceDoc in snapshot.docs) {
      var priceData = priceDoc.data() as Map<String, dynamic>;
      var storeDoc = await FirebaseFirestore.instance
          .collection('stores')
          .doc(priceData['storeID'])
          .get();
      var storeData = storeDoc.data() as Map<String, dynamic>;

      // Létrehozzuk az ár és áruház adatait tartalmazó objektumot és hozzáadjuk a listához
      priceAndStoreList.add(PriceAndStore(
          storeName: storeData['storeName'], price: priceData['price']));
    }
    return priceAndStoreList;
  });
});
