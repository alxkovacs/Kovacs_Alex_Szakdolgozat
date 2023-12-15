import 'package:application/model/price_and_store_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductScreenService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<PriceAndStoreDTO>> getPriceAndStoreListDTO(
      String productId) async {
    Map<String, List<int>> storePrices = {};

    var productPriceSnapshot = await _db
        .collection('productPrices')
        .where('productId', isEqualTo: productId)
        .get();
    for (var doc in productPriceSnapshot.docs) {
      String storeId = doc['storeId'];
      int price = doc['price'];
      storePrices.putIfAbsent(storeId, () => []).add(price);
    }

    List<PriceAndStoreDTO> priceAndStoreDTOs = [];
    for (var storeId in storePrices.keys) {
      var storeSnapshot = await _db.collection('stores').doc(storeId).get();
      String storeName = storeSnapshot.data()?['name'] ?? '';

      priceAndStoreDTOs.add(PriceAndStoreDTO(
        storeId: storeId,
        storeName: storeName,
        prices: storePrices[storeId]!,
      ));
    }

    return priceAndStoreDTOs;
  }

  Future<void> addProductToShoppingList(String productId, String userId) async {
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
    }
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
    bool isAlreadyFavorited = await isProductFavorited(productId, userId);
    if (!isAlreadyFavorited) {
      await _db.collection('favoriteProducts').add({
        'productId': productId,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> removeProductFromFavorites(
      String productId, String userId) async {
    var favoritesRef = _db
        .collection('favoriteProducts')
        .where('productId', isEqualTo: productId)
        .where('userId', isEqualTo: userId);
    var querySnapshot = await favoritesRef.get();
    if (querySnapshot.docs.isNotEmpty) {
      await _db
          .collection('favoriteProducts')
          .doc(querySnapshot.docs.first.id)
          .delete();
    }
  }

  Future<void> incrementProductViewCount(String productId) async {
    var productRef = _db.collection('products').doc(productId);
    await productRef.update({
      'viewCount': FieldValue.increment(1),
    });
  }

  Future<bool> addPriceWithTimestamp(
      String productId, String storeName, int price) async {
    try {
      var storeRef = _db.collection('stores').doc();
      var storeQuery = await _db
          .collection('stores')
          .where('name', isEqualTo: storeName)
          .get();

      if (storeQuery.docs.isEmpty) {
        await storeRef.set({
          'name': storeName,
          'name_lowercase': storeName.toLowerCase(),
        });
      } else {
        storeRef = _db.collection('stores').doc(storeQuery.docs.first.id);
      }

      await _db.collection('productPrices').add({
        'productId': productId,
        'storeId': storeRef.id,
        'price': price,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (err) {
      return false;
    }
  }
}
