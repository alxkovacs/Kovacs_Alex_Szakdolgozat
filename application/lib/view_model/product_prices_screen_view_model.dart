import 'package:application/model/product_price_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductPricesScreenViewModel extends ChangeNotifier {
  List<ProductPriceModel> prices = [];
  bool isLoading = true; // Betöltési állapot kezdeti értéke
  bool hasError = false; // Hibakezelés alapállapota
  String errorMessage = ''; // Hibakezeléshez szükséges üzenet

  Future<void> fetchPrices(String productId, String storeId) async {
    try {
      isLoading = true;
      notifyListeners(); // Fontos, hogy azonnal értesítse a hallgatókat

      var snapshot = await FirebaseFirestore.instance
          .collection('productPrices')
          .where('productId', isEqualTo: productId)
          .where('storeId', isEqualTo: storeId)
          .get();

      prices = snapshot.docs
          .map((doc) => ProductPriceModel.fromFirestore(
              doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      notifyListeners(); // Frissítse a felületet a hiba állapotával
    } finally {
      isLoading = false;
      notifyListeners(); // Biztosítja, hogy a betöltési állapot frissüljön
    }
  }
}
