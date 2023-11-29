import 'package:application/model/favorite.dart';
import 'package:application/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Product>> getShoppingListStream(String userId) {
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
      List<Product> productList = [];
      for (var productDoc in shoppingListProductsSnapshot.docs) {
        var productId = productDoc.get('productId');
        var productSnapshot =
            await _db.collection('products').doc(productId).get();

        // Létrehozzuk a Product példányt a lekért termék adatokkal
        var productData = productSnapshot.data();
        if (productData != null) {
          productList.add(Product(
            id: productSnapshot.id,
            name: productData['name'],
            categoryName: productData['category']['name'],
            categoryEmoji: productData['category']['emoji'],
          ));
        }
      }
      return productList;
    });
  }

  CollectionReference collection(String path) {
    return _db.collection(path);
  }

  Future<void> incrementProductViewCount(String productId) async {
    var productRef = _db.collection('products').doc(productId);

    // Növeld a viewCount mezőt egyel
    await productRef.update({
      'viewCount': FieldValue.increment(1),
    });
  }

  Future<void> incrementOfferViewCount(String offerId) async {
    var productRef = _db.collection('offers').doc(offerId);

    // Növeld a viewCount mezőt egyel
    await productRef.update({
      'viewCount': FieldValue.increment(1),
    });
  }

  Future<void> addOrUpdateProduct(String productName, String categoryName,
      String categoryEmoji, String storeName, int price) async {
    // Lekérjük vagy létrehozunk egy új termék azonosítót
    var productRef = _db.collection('products').doc();

    // Ellenőrizzük, hogy a termék létezik-e már név alapján
    var productQuery = await _db
        .collection('products')
        .where('name', isEqualTo: productName)
        .get();
    if (productQuery.docs.isEmpty) {
      // Ha nem létezik, létrehozunk egy új terméket
      await productRef.set({
        'name': productName,
        'name_lowercase': productName.toLowerCase(),
        'category': {
          'name': categoryName,
          'emoji': categoryEmoji,
        },
        'viewCount': 0,
      });
    } else {
      // Ha létezik, megszerezzük a meglévő termék azonosítóját
      productRef = _db.collection('products').doc(productQuery.docs.first.id);
    }

    // Lekérjük vagy létrehozunk egy új áruház azonosítót
    var storeRef = _db.collection('stores').doc();

    // Ellenőrizzük, hogy az áruház létezik-e már név alapján
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

    // Hozzáadjuk a termék árát a productPrice táblához
    await _db.collection('productPrices').add({
      'productId': productRef.id,
      'storeId': storeRef.id,
      'price': price,
      'timestamp': FieldValue.serverTimestamp(),
    });
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

  Stream<List<Favorite>> getFavoritesStream(String userId) {
    // Először lekérdezzük az összes kedvenc termékazonosítót
    return _db
        .collection('favoriteProducts')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((favoritesSnapshot) async {
      // Majd minden kedvenc termékazonosítóhoz lekérjük a termék adatait a products táblából
      List<Favorite> favorites = [];
      for (var favoriteDoc in favoritesSnapshot.docs) {
        String productId = favoriteDoc.get('productId');
        var productSnapshot =
            await _db.collection('products').doc(productId).get();
        favorites.add(Favorite.fromDocument(productSnapshot));
      }
      return favorites;
    });
  }

  // Új függvények az áruházak kedvenc kezelésére
  Future<bool> isStoreFavorited(String storeId, String userId) async {
    var favoritesRef = _db
        .collection('favoriteStores')
        .where('storeId', isEqualTo: storeId)
        .where('userId', isEqualTo: userId);
    var querySnapshot = await favoritesRef.get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addStoreToFavorites(String storeId, String userId) async {
    bool isAlreadyFavorited = await isStoreFavorited(storeId, userId);
    if (!isAlreadyFavorited) {
      await _db.collection('favoriteStores').add({
        'storeId': storeId,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> removeStoreFromFavorites(String storeId, String userId) async {
    var favoritesRef = _db
        .collection('favoriteStores')
        .where('storeId', isEqualTo: storeId)
        .where('userId', isEqualTo: userId);
    var querySnapshot = await favoritesRef.get();
    if (querySnapshot.docs.isNotEmpty) {
      await _db
          .collection('favoriteStores')
          .doc(querySnapshot.docs.first.id)
          .delete();
    }
  }

// Stream a kedvenc áruházak lekérdezéséhez
  Stream<List<String>> getFavoriteStoresStream(String userId) {
    return _db
        .collection('favoriteStores')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['storeId'] as String).toList());
  }

  Future<String> getStoreNameById(String id) async {
    var snapshot = await _db.collection('stores').doc(id).get();
    if (snapshot.exists && snapshot.data()!.containsKey('name')) {
      return snapshot.data()!['name'] as String;
    } else {
      throw Exception('A keresett áruház nem létezik.');
    }
  }
}
