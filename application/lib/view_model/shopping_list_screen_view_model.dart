import 'package:application/model/product_model.dart';
import 'package:application/utils/translation_en.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// A bevásárlólista stream provider-e, ami az adott felhasználó bevásárlólistáját figyeli

class ShoppingListScreenViewModel extends ChangeNotifier {
  late final FirebaseFirestore _db;

  ShoppingListScreenViewModel() {
    _db = FirebaseFirestore.instance;
  }

  Stream<List<ProductModel>> getShoppingListStream(String userId) {
    // Először meghatározzuk a felhasználó bevásárlólistájának ID-ját
    return _db
        .collection('shoppingLists')
        .where('userId', isEqualTo: userId)
        .limit(1) // Feltételezve, hogy egy felhasználóhoz egy lista tartozik
        .snapshots()
        .asyncMap((shoppingListSnapshot) async {
      // Üres lista, ha nincs bevásárlólista
      if (shoppingListSnapshot.docs.isEmpty) {
        return [];
      }
      // Megvan a bevásárlólista ID
      var shoppingListId = shoppingListSnapshot.docs.first.id;

      // Lekérdezzük a bevásárlólistához tartozó termékeket
      var shoppingListProductsSnapshot = await _db
          .collection('shoppingListProducts')
          .where('shoppingListId', isEqualTo: shoppingListId)
          .get();

      // Lekérjük a termékeket azonosítók alapján
      List<ProductModel> productList = [];
      for (var productDoc in shoppingListProductsSnapshot.docs) {
        var productId = productDoc.get('productId');
        var productSnapshot =
            await _db.collection('products').doc(productId).get();

        // Létrehozzuk a Product példányt a lekért termék adatokkal
        var productData = productSnapshot.data();
        if (productData != null) {
          productList.add(ProductModel(
            id: productSnapshot.id,
            product: productData['name'],
            category: productData['category']['name'],
            emoji: productData['category']['emoji'],
          ));
        }
      }
      return productList;
    });
  }

  Future<void> removeProductFromShoppingList(
      String shoppingListId, String productId) async {
    try {
      // Töröljük a terméket a bevásárlólistáról
      final snapshot = await FirebaseFirestore.instance
          .collection('shoppingListProducts')
          .where('shoppingListId', isEqualTo: shoppingListId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('shoppingListProducts')
            .doc(snapshot.docs.first.id)
            .delete();
      }
    } catch (e) {
      // Kezelje a hibákat itt, pl. logolás vagy felhasználói értesítés
      print(e);
    }
  }

  Future<List<String>> getFavoriteStoreIds(String userId) async {
    // Access Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Retrieve favorite store document references for the given user
    final favoriteStoresSnapshot = await firestore
        .collection('favoriteStores')
        .where('userId', isEqualTo: userId)
        .get();

    // Extract store IDs from documents
    return favoriteStoresSnapshot.docs
        .map((doc) => doc.data()['storeId'] as String)
        .toList();
  }

  Future<List<String>> getShoppingListProductIds(String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Assuming each user has one shopping list, retrieve it
    final shoppingListSnapshot = await firestore
        .collection('shoppingLists')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    // Assuming the shopping list ID is known (from the snapshot above)
    String shoppingListId = shoppingListSnapshot.docs.first.id;

    // Retrieve product IDs from the shopping list
    final shoppingListProductsSnapshot = await firestore
        .collection('shoppingListProducts')
        .where('shoppingListId', isEqualTo: shoppingListId)
        .get();

    return shoppingListProductsSnapshot.docs
        .map((doc) => doc.data()['productId'] as String)
        .toList();
  }

  Future<int> getProductPrice(String productId, String storeId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Retrieve the price of the product for the specified store
    final priceSnapshot = await firestore
        .collection('productPrices')
        .where('productId', isEqualTo: productId)
        .where('storeId', isEqualTo: storeId)
        .limit(1)
        .get();

    // Assuming there is a price document for the product in the store
    if (priceSnapshot.docs.isNotEmpty) {
      return priceSnapshot.docs.first.data()['price'] as int;
    } else {
      return 0; // or handle the case where there is no price for the product in the store
    }
  }

  Future<List<Map<String, dynamic>>> getFavoriteStoresTotal(
      String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<String> favoriteStoreIds = await getFavoriteStoreIds(userId);
    List<String> shoppingListProductIds =
        await getShoppingListProductIds(userId);
    Map<String, List<int>> storeProductPrices = {};
    Map<String, int> productAvailabilityCount = {};

    // Gyűjtsük össze az árakat minden áruházban minden termékhez
    for (String productId in shoppingListProductIds) {
      final pricesSnapshot = await firestore
          .collection('productPrices')
          .where('productId', isEqualTo: productId)
          .get();

      for (var priceDoc in pricesSnapshot.docs) {
        String storeId = priceDoc.data()['storeId'] as String;
        if (!favoriteStoreIds.contains(storeId))
          continue; // Csak a kedvenc áruházak
        int price = priceDoc.data()['price'] as int;
        String storeProductKey = '$storeId-$productId';

        if (!storeProductPrices.containsKey(storeProductKey)) {
          storeProductPrices[storeProductKey] = [];
        }
        storeProductPrices[storeProductKey]!.add(price);
      }
    }

    // Kiszámítjuk a medián árakat
    Map<String, int> storeMedians = {};
    storeProductPrices.forEach((key, prices) {
      storeMedians[key] = _calculateMedian(prices);
    });

    // Az összegzett árak frissítése
    Map<String, int> storeTotals = {};
    storeMedians.forEach((key, medianPrice) {
      var parts = key.split('-');
      String storeId = parts[0];

      if (!productAvailabilityCount.containsKey(storeId)) {
        productAvailabilityCount[storeId] = 0;
      }
      productAvailabilityCount[storeId] =
          productAvailabilityCount[storeId]! + 1;

      if (!storeTotals.containsKey(storeId)) {
        storeTotals[storeId] = 0;
      }
      storeTotals[storeId] = storeTotals[storeId]! + medianPrice;
    });

    // Kiszűrjük a kedvenc áruházakat
    var favoriteStoresWithAllProducts = storeTotals.entries.where((entry) =>
        productAvailabilityCount[entry.key] == shoppingListProductIds.length);

    // Visszaadjuk a kedvenc áruházak listáját a nevekkel kiegészítve
    List<Map<String, dynamic>> favoriteStoresTotals = [];
    for (var storeEntry in favoriteStoresWithAllProducts) {
      final storeId = storeEntry.key;
      final total = storeEntry.value;

      final storeDetailsSnapshot =
          await firestore.collection('stores').doc(storeId).get();

      if (!storeDetailsSnapshot.exists) {
        continue; // Ha az áruház nem létezik, kihagyjuk
      }
      String storeName = storeDetailsSnapshot.data()!['name'] as String;

      favoriteStoresTotals.add({
        'storeId': storeId,
        'storeName': storeName,
        'total': total,
      });
    }

    return favoriteStoresTotals;
  }

  Future<Map<String, dynamic>> getCheapestStoreTotal(String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<String> shoppingListProductIds =
        await getShoppingListProductIds(userId);

    Map<String, List<int>> storeProductPrices = {};
    Map<String, int> productAvailabilityCount = {};

    // Gyűjtsük össze az árakat minden áruházban minden termékhez
    for (String productId in shoppingListProductIds) {
      final pricesSnapshot = await firestore
          .collection('productPrices')
          .where('productId', isEqualTo: productId)
          .get();

      for (var priceDoc in pricesSnapshot.docs) {
        String storeId = priceDoc.data()['storeId'] as String;
        int price = priceDoc.data()['price'] as int;

        String storeProductKey = '$storeId-$productId';

        if (!storeProductPrices.containsKey(storeProductKey)) {
          storeProductPrices[storeProductKey] = [];
        }

        storeProductPrices[storeProductKey]!.add(price);
      }
    }

    // Számoljuk ki a medián árat minden termékhez minden áruházban
    Map<String, int> storeMedians = {};
    storeProductPrices.forEach((key, prices) {
      storeMedians[key] = _calculateMedian(prices);
    });

    // Frissítsük az elérhetőségi számot és az összegzett árat az áruházankénti medián árak alapján
    Map<String, int> storeTotals = {};
    storeMedians.forEach((key, medianPrice) {
      var parts = key.split('-');
      String storeId = parts[0];

      if (!productAvailabilityCount.containsKey(storeId)) {
        productAvailabilityCount[storeId] = 0;
      }

      productAvailabilityCount[storeId] =
          productAvailabilityCount[storeId]! + 1;

      if (!storeTotals.containsKey(storeId)) {
        storeTotals[storeId] = 0;
      }

      storeTotals[storeId] = storeTotals[storeId]! + medianPrice;
    });

    // Kiszűrjük azokat az áruházakat, ahol minden termék megtalálható
    var storesWithAllProducts = storeTotals.entries.where((entry) =>
        productAvailabilityCount[entry.key] == shoppingListProductIds.length);

    // Megkeressük a legolcsóbb összértékű áruházat
    Map<String, dynamic> cheapestStore = {};
    int? cheapestPrice;
    for (var storeEntry in storesWithAllProducts) {
      final storeId = storeEntry.key;
      final total = storeEntry.value;

      if (cheapestPrice == null || total < cheapestPrice) {
        cheapestPrice = total;
        cheapestStore = {
          'storeId': storeId,
          'total': total,
        };
      }
    }

    if (cheapestStore.isEmpty) {
      return {TranslationEN.error: TranslationEN.noStoreEveryProductAvailable};
    }

// Itt kérdezzük le az üzlet nevét a storeId alapján
    final storeDetailsSnapshot = await firestore
        .collection('stores')
        .doc(cheapestStore['storeId'])
        .get();

    if (!storeDetailsSnapshot.exists) {
      return {TranslationEN.error: TranslationEN.noStoreAvailable};
    }

// Mivel megtaláltuk az áruházat, hozzárendeljük az áruház nevét
    String storeName = storeDetailsSnapshot.data()!['name'] as String;
    cheapestStore['storeName'] = storeName;

    return cheapestStore;
  }

  int _calculateMedian(List<int> prices) {
    prices.sort();
    int middle = prices.length ~/ 2;
    if (prices.length % 2 == 1) {
      return prices[middle];
    } else {
      return ((prices[middle - 1] + prices[middle]) / 2).round();
    }
  }
}
