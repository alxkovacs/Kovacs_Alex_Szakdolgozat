import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:application/model/product_price_model.dart';

class ProductPricesScreenService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ProductPriceModel>> fetchPrices(
      String productId, String storeId) {
    return _db
        .collection('productPrices')
        .where('productId', isEqualTo: productId)
        .where('storeId', isEqualTo: storeId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductPriceModel.fromFirestore(
                doc.data() as Map<String, dynamic>))
            .toList());
  }
}
