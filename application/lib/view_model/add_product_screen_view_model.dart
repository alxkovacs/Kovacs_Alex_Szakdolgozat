import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProductScreenViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> addOrUpdateProduct(String productName, String categoryName,
      String categoryEmoji, String storeName, int price) async {
    setLoading(true);
    try {
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

      setLoading(false);
      return true; // Sikeres művelet esetén
    } catch (e) {
      setLoading(false);
      return false; // Hiba esetén
    }
  }
}
