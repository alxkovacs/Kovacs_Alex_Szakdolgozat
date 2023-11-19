import 'package:application/model/price_and_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final priceAndStoreProvider =
//     StreamProvider.family<List<PriceAndStore>, String>((ref, String productId) {
//   // A stream lekérdezése, ami figyeli az adott termékhez tartozó árakat
//   return FirebaseFirestore.instance
//       .collection('productPrice')
//       .where('productID', isEqualTo: productId)
//       .snapshots()
//       .asyncMap((snapshot) async {
//     List<PriceAndStore> priceAndStoreList = [];

//     // Minden egyes ár adatainak lekérdezése
//     for (var priceDoc in snapshot.docs) {
//       var priceData = priceDoc.data() as Map<String, dynamic>;
//       var storeDoc = await FirebaseFirestore.instance
//           .collection('stores')
//           .doc(priceData['storeID'])
//           .get();
//       var storeData = storeDoc.data() as Map<String, dynamic>;

//       // Létrehozzuk az ár és áruház adatait tartalmazó objektumot és hozzáadjuk a listához
//       priceAndStoreList.add(PriceAndStore(
//           productId: productId,
//           storeName: storeData['storeName'],
//           price: priceData['price']));
//     }
//     // Rendezzük a listát ár szerint, ha szükséges
//     priceAndStoreList.sort((a, b) => a.price.compareTo(b.price));
//     return priceAndStoreList;
//   });
// });

final priceAndStoreProvider =
    StreamProvider.family<List<PriceAndStore>, String>((ref, productId) {
  return FirebaseFirestore.instance
      .collection('productPrices')
      .where('productId', isEqualTo: productId)
      .snapshots()
      .asyncMap((snapshot) async {
    Map<String, List<int>> storePrices = {};

    // Gyűjtjük az árakat áruházanként
    for (var doc in snapshot.docs) {
      String storeId = doc['storeId'];
      int price = doc['price'];
      storePrices.putIfAbsent(storeId, () => []).add(price);
    }

    List<PriceAndStore> priceAndStores = [];
    for (var storeId in storePrices.keys) {
      // Lekérdezzük az áruház adatait
      var storeSnapshot = await FirebaseFirestore.instance
          .collection('stores')
          .doc(storeId)
          .get();
      String storeName = storeSnapshot['name'];

      // Számítjuk a mediánt
      List<int> prices = storePrices[storeId]!;
      int medianPrice = _calculateMedian(prices);

      // Létrehozzuk az objektumot az áruház nevével, medián árral és az árak számával
      priceAndStores.add(PriceAndStore(
        storeId: storeId,
        storeName: storeName,
        price: medianPrice,
        priceCount: prices.length, // Hány darab ár van
      ));
    }

    // Rendezzük az ár szerint
    priceAndStores.sort((a, b) => a.price.compareTo(b.price));

    return priceAndStores;
  });
});

// Segédfüggvény a medián számításához
int _calculateMedian(List<int> prices) {
  prices.sort();
  int middle = prices.length ~/ 2;
  if (prices.length % 2 == 1) {
    return prices[middle];
  } else {
    return ((prices[middle - 1] + prices[middle]) / 2).round();
  }
}
