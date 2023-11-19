import 'package:application/model/price_and_store.dart';
import 'package:application/model/shopping_list_product.dart';
import 'package:application/providers/firebase_user_provider.dart';
import 'package:application/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingListProduct>>(
        (ref) {
  final notifier = ShoppingListNotifier(ref);

  // Előfizetés a felhasználó állapotára
  void listenToUserChanges(User? user) {
    if (user != null) {
      notifier.loadShoppingList(user.uid);
    } else {
      notifier.clearShoppingList();
    }
  }

  // Hallgatózik a felhasználó állapotának változásaira
  final userSubscription = ref.listen<User?>(
    firebaseUserProvider as AlwaysAliveProviderListenable<User?>,
    (_, user) => listenToUserChanges(user),
  );

  // Tisztítja az előfizetést, amikor a provider nem szükséges
  ref.onDispose(() {
    userSubscription;
  });

  return notifier;
});

class ShoppingListNotifier extends StateNotifier<List<ShoppingListProduct>> {
  final Ref ref;

  ShoppingListNotifier(this.ref) : super([]);

  Future<void> addProductToShoppingList(PriceAndStore product) async {
    try {
      final firebaseUser = ref.read(firebaseUserProvider).asData?.value;

      if (firebaseUser != null) {
        final shoppingLists =
            FirebaseFirestore.instance.collection('shoppinglists');
        final shoppingListProduct =
            FirebaseFirestore.instance.collection('shoppingListProduct');

        // Ellenőrizzük, hogy van-e már bevásárlólista
        final shoppingListQuery = await shoppingLists
            .where('userId', isEqualTo: firebaseUser.uid)
            .limit(1)
            .get();
        final shoppingListId = shoppingListQuery.docs.isNotEmpty
            ? shoppingListQuery.docs.first.id
            : await createShoppingList(shoppingLists, firebaseUser.uid);

        // Adjuk hozzá a terméket a bevásárlólistához
        // await shoppingListProduct.add({
        //   'shoppingListId': shoppingListId,
        //   'productId': product
        //       .productId, // Feltételezzük, hogy van productId meződ a PriceAndStore-ban
        // });

        // Frissítsük az állapotot
        // state = [
        //   ...state,
        //   new ShoppingListProduct(
        //       shoppingListId: shoppingListId, productId: product.productId)
        // ];
      }
    } catch (e) {
      // Kezeld a kivételeket, pl. hálózati hiba esetén
      print(e.toString());
    }
  }

  Future<String> createShoppingList(
      CollectionReference shoppingLists, String userId) async {
    final newList = await shoppingLists.add({'userId': userId});
    return newList.id;
  }

  // Betölti a megadott felhasználó bevásárlólistáját a Firestore-ból
  Future<void> loadShoppingList(String userId) async {
    try {
      final shoppingListProduct =
          FirebaseFirestore.instance.collection('shoppingListProduct');
      final querySnapshot =
          await shoppingListProduct.where('userId', isEqualTo: userId).get();

      // Konvertálja a lekérdezés eredményét `ShoppingListProduct` objektumok listájává
      final shoppingList = querySnapshot.docs
          .map((doc) => ShoppingListProduct.fromFirestore(doc))
          .toList();

      // Frissíti az állapotot az újonnan betöltött listával
      state = shoppingList;
    } catch (e) {
      // Hiba esetén logolja a hibát
      print(e.toString());
    }
  }

  // Törli a bevásárlólista állapotát
  void clearShoppingList() {
    state = [];
  }
}
