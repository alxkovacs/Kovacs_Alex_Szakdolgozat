import 'package:application/model/product_model.dart';
import 'package:application/utils/translation_en.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OfferScreenViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String storeName = '';
  List<ProductModel> products = [];

  Future<void> fetchStoreName(String storeId) async {
    try {
      var storeDocument = await FirebaseFirestore.instance
          .collection('stores')
          .doc(storeId)
          .get();
      storeName = storeDocument.data()?['name'] ?? TranslationEN.unknownStore;
      notifyListeners();
    } catch (e) {
      // Kezeld a lehetséges hibákat
      print('${TranslationEN.errorStoreQuery}: $e');
    }
  }

  Future<void> fetchOfferProducts(String offerId) async {
    try {
      var offerItemsQuery = await FirebaseFirestore.instance
          .collection('offerItems')
          .where('offerId', isEqualTo: offerId)
          .get();

      List<ProductModel> fetchedProducts = [];
      for (var offerItem in offerItemsQuery.docs) {
        var productId = offerItem.data()['productId'];
        var productDocument = await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();
        var productData = productDocument.data();
        if (productData != null) {
          fetchedProducts.add(ProductModel(
            id: productDocument.id,
            product: productData['name'] as String? ??
                '', // Alapértelmezett érték, ha nincs név
            category: productData['category'] is Map
                ? productData['category']['name'] as String? ??
                    TranslationEN
                        .unknownCategory // Alapértelmezett érték, ha nincs kategória
                : TranslationEN.unknownCategory,
            emoji: productData['category'] is Map
                ? productData['category']['emoji'] as String? ??
                    '' // Alapértelmezett érték, ha nincs emoji
                : '',
          ));
        }
      }
      products = fetchedProducts;
      notifyListeners();
    } catch (e) {
      // Kezeld a lehetséges hibákat
      print('${TranslationEN.errorProductQuery}: $e');
    }
  }

  Future<void> incrementOfferViewCount(String offerId) async {
    var productRef = _db.collection('offers').doc(offerId);

    // Növeld a viewCount mezőt egyel
    await productRef.update({
      'viewCount': FieldValue.increment(1),
    });
  }
}
