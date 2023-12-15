import 'package:application/model/product_price_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductPricesScreenService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ProductPriceDTO>> fetchPrices(String productId, String storeId) {
    return _db
        .collection('productPrices')
        .where('productId', isEqualTo: productId)
        .where('storeId', isEqualTo: storeId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductPriceDTO.fromFirestore(
                doc.data() as Map<String, dynamic>))
            .toList());
  }
}
