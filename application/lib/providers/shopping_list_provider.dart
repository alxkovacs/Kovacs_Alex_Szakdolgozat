import 'package:application/model/product.dart';
import 'package:application/services/database_service.dart';
import 'package:application/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Globális provider a DatabaseService-hez, hogy hozzáférjünk az adatbázis műveletekhez
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService(); // A DatabaseService konstruktora
});

// A bevásárlólista stream provider-e, ami az adott felhasználó bevásárlólistáját figyeli
final shoppingListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final database = ref.read(databaseServiceProvider);
  final userId = FirebaseAuth.instance.currentUser!.uid;
  return database.getShoppingListStream(userId);
});

final shoppingListProvider = Provider<ShoppingListProvider>((ref) {
  return ShoppingListProvider(ref);
});

class ShoppingListProvider {
  final Ref ref; // Használjuk a Ref osztályt a Reader helyett
  FirestoreService get firestoreService =>
      ref.read(firestoreServiceProvider); // Így olvashatjuk ki a szolgáltatást

  ShoppingListProvider(this.ref);

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

  Future<List<Map<String, dynamic>>> getFavoriteStoresTotal(
      String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<String> favoriteStoreIds =
        await firestoreService.getFavoriteStoreIds(userId);
    List<String> shoppingListProductIds =
        await firestoreService.getShoppingListProductIds(userId);
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
        await firestoreService.getShoppingListProductIds(userId);

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
      return {'error': 'Nincs áruház, ahol minden termék elérhető'};
    }

// Itt kérdezzük le az üzlet nevét a storeId alapján
    final storeDetailsSnapshot = await firestore
        .collection('stores')
        .doc(cheapestStore['storeId'])
        .get();

    if (!storeDetailsSnapshot.exists) {
      return {'error': 'Az áruház nem található'};
    }

// Mivel megtaláltuk az áruházat, hozzárendeljük az áruház nevét
    String storeName = storeDetailsSnapshot.data()!['name'] as String;
    cheapestStore['storeName'] = storeName;
// cheapestStore.remove('storeId'); // Ha nem szeretnéd megtartani a storeId-t

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

// Don't forget to create a provider for your FirestoreService as well
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});
