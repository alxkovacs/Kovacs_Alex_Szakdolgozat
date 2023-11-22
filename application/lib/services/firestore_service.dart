import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
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

  // Future<Map<String, dynamic>> getCheapestStoreTotal(
  //     List<String> productIds) async {
  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //   // This is a more complex query which would require aggregation, not directly supported in Firestore
  //   // As an alternative, fetch all prices and then process them locally

  //   Map<String, int> storeTotals = {};

  //   for (String productId in productIds) {
  //     // Get all prices for a product across all stores
  //     final pricesSnapshot = await firestore
  //         .collection('productPrices')
  //         .where('productId', isEqualTo: productId)
  //         .get();

  //     // Update the total price for each store
  //     for (var priceDoc in pricesSnapshot.docs) {
  //       String storeId = priceDoc.data()['storeId'] as String;
  //       int price = priceDoc.data()['price'] as int;
  //       storeTotals.update(storeId, (total) => total + price,
  //           ifAbsent: () => price);
  //     }
  //   }

  //   // Find the store with the minimum total price
  //   String cheapestStoreId = storeTotals.entries
  //       .reduce((curr, next) => curr.value < next.value ? curr : next)
  //       .key;
  //   int cheapestPrice = storeTotals[cheapestStoreId]!;

  //   return {'storeId': cheapestStoreId, 'total': cheapestPrice};
  // }
}
