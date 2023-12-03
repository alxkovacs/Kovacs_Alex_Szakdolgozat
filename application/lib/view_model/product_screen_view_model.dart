import 'package:application/model/price_and_store_model.dart';
import 'package:application/utils/translation_en.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final priceAndStoreProvider =
    StreamProvider.family<List<PriceAndStoreModel>, String>((ref, productId) {
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

    List<PriceAndStoreModel> priceAndStores = [];
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
      priceAndStores.add(PriceAndStoreModel(
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

class ProductScreenViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  void Function(String message)? onProductAddedToShoppingList;
  bool isLoading = false;
  bool isFavorite = false;

  Future<void> addProductToShoppingList(String productId, String userId) async {
    try {
      QuerySnapshot shoppingListSnapshot = await _db
          .collection('shoppingLists')
          .where('userId', isEqualTo: userId)
          .get();

      DocumentReference shoppingListRef;
      if (shoppingListSnapshot.docs.isEmpty) {
        shoppingListRef = await _db.collection('shoppingLists').add({
          'userId': userId,
          'createdOn': FieldValue.serverTimestamp(),
        });
      } else {
        shoppingListRef = shoppingListSnapshot.docs.first.reference;
      }

      QuerySnapshot shoppingListProductsSnapshot = await _db
          .collection('shoppingListProducts')
          .where('shoppingListId', isEqualTo: shoppingListRef.id)
          .where('productId', isEqualTo: productId)
          .get();

      if (shoppingListProductsSnapshot.docs.isEmpty) {
        await _db.collection('shoppingListProducts').add({
          'shoppingListId': shoppingListRef.id,
          'productId': productId,
          'addedOn': FieldValue.serverTimestamp(),
        });
        // Sikeres hozzáadás esetén
        onProductAddedToShoppingList
            ?.call(TranslationEN.productAddedToShoppingList);
      }
      // Hiba vagy másik üzenet kezelése
    } catch (e) {
      // Hiba kezelése
    }
  }

  Future<void> checkFavoriteStatus(String productId, String? userId) async {
    if (userId == null) {
      // Handle no user case
      return;
    }
    isFavorite = await isProductFavorited(productId, userId);
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId, String? userId) async {
    isLoading = true;
    notifyListeners();
    if (userId == null) {
      // Handle no user case
      return;
    }
    if (isFavorite) {
      await removeProductFromFavorites(productId, userId);
    } else {
      await addProductToFavorites(productId, userId);
    }
    isFavorite = !isFavorite;
    isLoading = false;
    notifyListeners();
  }

  CollectionReference collection(String path) {
    return _db.collection(path);
  }

  Future<void> addPriceWithTimestamp(
      String productId, String storeName, int price) async {
    // Lekérjük vagy létrehozunk egy új áruház azonosítót
    var storeRef = _db.collection('stores').doc();
    var storeQuery = await _db
        .collection('stores')
        .where('name', isEqualTo: storeName)
        .get();

    if (storeQuery.docs.isEmpty) {
      // Ha nem létezik, létrehozunk egy új áruházat
      await storeRef.set({
        'name': storeName,
        'name_lowercase': storeName.toLowerCase(),
      });
    } else {
      // Ha létezik, megszerezzük a meglévő áruház azonosítóját
      storeRef = _db.collection('stores').doc(storeQuery.docs.first.id);
    }

    // Hozzáadjuk a termék árát és a jelenlegi időpontot a productPrices táblához
    await _db.collection('productPrices').add({
      'productId': productId,
      'storeId': storeRef.id,
      'price': price,
      'timestamp': FieldValue
          .serverTimestamp(), // Ez hozzáadja a szerver aktuális időpontját
    });
  }

  Future<bool> isProductFavorited(String productId, String userId) async {
    var favoritesRef = _db
        .collection('favoriteProducts')
        .where('productId', isEqualTo: productId)
        .where('userId', isEqualTo: userId);
    var querySnapshot = await favoritesRef.get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addProductToFavorites(String productId, String userId) async {
    // Check if the product is already favorited to avoid duplicates
    bool isAlreadyFavorited = await isProductFavorited(productId, userId);
    if (!isAlreadyFavorited) {
      await _db.collection('favoriteProducts').add({
        'productId': productId,
        'userId': userId,
        'timestamp': FieldValue
            .serverTimestamp(), // Optional: to track when the product was favorited
      });
    }
  }

  Future<void> removeProductFromFavorites(
      String productId, String userId) async {
    // Retrieve the document reference of the favorite entry
    var favoritesRef = _db
        .collection('favoriteProducts')
        .where('productId', isEqualTo: productId)
        .where('userId', isEqualTo: userId);
    var querySnapshot = await favoritesRef.get();

    // There should only be one entry due to the uniqueness of the combination of productId and userId
    if (querySnapshot.docs.isNotEmpty) {
      await _db
          .collection('favoriteProducts')
          .doc(querySnapshot.docs.first.id)
          .delete();
    }
  }

  Future<void> incrementProductViewCount(String productId) async {
    var productRef = _db.collection('products').doc(productId);

    // Növeld a viewCount mezőt egyel
    await productRef.update({
      'viewCount': FieldValue.increment(1),
    });
  }

  Future<bool> addPrice(
      String productID, String enteredStore, String enteredPrice) async {
    try {
      await FirebaseFirestore.instance.collection('productPrice').doc().set({
        'productID': productID,
        'storeID': enteredStore,
        'price': int.parse(enteredPrice),
      });

      return true; // Sikeres regisztráció
    } catch (err) {
      return false; // Sikertelen regisztráció
    }
  }
}
