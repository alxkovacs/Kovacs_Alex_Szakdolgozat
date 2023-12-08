import 'package:application/model/product_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> addOrUpdateProduct(
      ProductDTO productDTO, String storeName, int price) async {
    try {
      var productRef = _db.collection('products').doc();

      var productQuery = await _db
          .collection('products')
          .where('name', isEqualTo: productDTO.name)
          .get();
      if (productQuery.docs.isEmpty) {
        await productRef.set(productDTO.toFirebaseJson());
      } else {
        productRef = _db.collection('products').doc(productQuery.docs.first.id);
      }

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
        'productId': productRef.id,
        'storeId': storeRef.id,
        'price': price,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
