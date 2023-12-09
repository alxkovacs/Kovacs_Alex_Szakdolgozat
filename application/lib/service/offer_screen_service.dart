import 'package:application/model/product_dto.dart';
import 'package:application/utils/translation_en.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfferService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> fetchStoreName(String storeId) async {
    var storeDocument = await _db.collection('stores').doc(storeId).get();
    return storeDocument.data()?['name'] ?? TranslationEN.unknownStore;
  }

  Future<List<ProductDTO>> fetchOfferProducts(String offerId) async {
    var offerItemsQuery = await _db
        .collection('offerItems')
        .where('offerId', isEqualTo: offerId)
        .get();

    List<ProductDTO> fetchedProducts = [];
    for (var offerItem in offerItemsQuery.docs) {
      var productId = offerItem.data()['productId'];
      var productDocument =
          await _db.collection('products').doc(productId).get();
      var productData = productDocument.data();
      if (productData != null) {
        fetchedProducts
            .add(ProductDTO.fromFirebaseJson(productData, productDocument.id));
      }
    }
    return fetchedProducts;
  }

  Future<void> incrementOfferViewCount(String offerId) async {
    var productRef = _db.collection('offers').doc(offerId);

    await productRef.update({
      'viewCount': FieldValue.increment(1),
    });
  }
}
