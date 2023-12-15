import 'package:application/utils/translation_en.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:application/model/product_dto.dart';
import 'package:application/model/store_dto.dart';

class ShoppingListScreenService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> listenToFavoritesChanges(String userId) {
    return _db
        .collection('favoriteStores')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      return await getFavoriteStoresTotal(userId);
    });
  }

  Stream<List<ProductDTO>> getShoppingListStream(String userId) async* {
    var shoppingListSnapshot = await _db
        .collection('shoppingLists')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (shoppingListSnapshot.docs.isEmpty) {
      yield [];
      return;
    }

    var shoppingListId = shoppingListSnapshot.docs.first.id;

    yield* _db
        .collection('shoppingListProducts')
        .where('shoppingListId', isEqualTo: shoppingListId)
        .snapshots()
        .asyncMap((snapshot) async {
      return await Future.wait(snapshot.docs.map((doc) async {
        var productId = doc.get('productId');
        var productSnapshot =
            await _db.collection('products').doc(productId).get();
        var productData = productSnapshot.data();
        if (productData != null) {
          return ProductDTO.fromFirebaseJson(productData, productSnapshot.id);
        } else {
          return ProductDTO(
              id: productSnapshot.id,
              name: '',
              category: '',
              emoji: '',
              viewCount: 0);
        }
      }));
    });
  }

  Future<void> removeProductFromShoppingList(
      String userId, String productId) async {
    try {
      var shoppingListSnapshot = await _db
          .collection('shoppingLists')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      var shoppingListId = shoppingListSnapshot.docs.first.id;

      var snapshot = await _db
          .collection('shoppingListProducts')
          .where('shoppingListId', isEqualTo: shoppingListId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await _db
            .collection('shoppingListProducts')
            .doc(snapshot.docs.first.id)
            .delete();
      }
    } catch (e) {
      print('${TranslationEN.error}: $e');
    }
  }

  Future<List<String>> getFavoriteStoreIds(String userId) async {
    var snapshot = await _db
        .collection('favoriteStores')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => doc.data()['storeId'] as String).toList();
  }

  Future<List<StoreDTO>> searchStores(String query) async {
    final lowercaseQuery = query.toLowerCase();
    final querySnapshot = await _db
        .collection('stores')
        .where('name_lowercase', isGreaterThanOrEqualTo: lowercaseQuery)
        .where('name_lowercase', isLessThanOrEqualTo: lowercaseQuery + '\uf8ff')
        .get();

    return querySnapshot.docs
        .map((doc) => StoreDTO.fromFirestore(doc))
        .toList();
  }

  Future<List<String>> getShoppingListProductIds(String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final shoppingListSnapshot = await firestore
        .collection('shoppingLists')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (shoppingListSnapshot.docs.isEmpty) {
      return [];
    }

    String shoppingListId = shoppingListSnapshot.docs.first.id;

    final shoppingListProductsSnapshot = await firestore
        .collection('shoppingListProducts')
        .where('shoppingListId', isEqualTo: shoppingListId)
        .get();

    return shoppingListProductsSnapshot.docs
        .map((doc) => doc.data()['productId'] as String)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getFavoriteStoresTotal(
      String userId) async {
    List<String> favoriteStoreIds = await getFavoriteStoreIds(userId);
    List<String> shoppingListProductIds =
        await getShoppingListProductIds(userId);
    Map<String, List<int>> storeProductPrices = {};
    Map<String, int> productAvailabilityCount = {};

    for (String productId in shoppingListProductIds) {
      final pricesSnapshot = await _db
          .collection('productPrices')
          .where('productId', isEqualTo: productId)
          .get();

      for (var priceDoc in pricesSnapshot.docs) {
        String storeId = priceDoc.data()['storeId'] as String;
        if (!favoriteStoreIds.contains(storeId)) continue;
        int price = priceDoc.data()['price'] as int;
        String storeProductKey = '$storeId-$productId';

        if (!storeProductPrices.containsKey(storeProductKey)) {
          storeProductPrices[storeProductKey] = [];
        }
        storeProductPrices[storeProductKey]!.add(price);
      }
    }

    Map<String, int> storeMedians = {};
    storeProductPrices.forEach((key, prices) {
      storeMedians[key] = _calculateMedian(prices);
    });

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

    var favoriteStoresWithAllProducts = storeTotals.entries.where((entry) =>
        productAvailabilityCount[entry.key] == shoppingListProductIds.length);

    List<Map<String, dynamic>> favoriteStoresTotals = [];
    for (var storeEntry in favoriteStoresWithAllProducts) {
      final storeId = storeEntry.key;
      final total = storeEntry.value;

      final storeDetailsSnapshot =
          await _db.collection('stores').doc(storeId).get();

      if (!storeDetailsSnapshot.exists) {
        continue;
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

    Map<String, int> storeMedians = {};
    storeProductPrices.forEach((key, prices) {
      storeMedians[key] = _calculateMedian(prices);
    });

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

    var storesWithAllProducts = storeTotals.entries.where((entry) =>
        productAvailabilityCount[entry.key] == shoppingListProductIds.length);

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

    final storeDetailsSnapshot = await firestore
        .collection('stores')
        .doc(cheapestStore['storeId'])
        .get();

    if (!storeDetailsSnapshot.exists) {
      return {TranslationEN.error: TranslationEN.noStoreAvailable};
    }

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
