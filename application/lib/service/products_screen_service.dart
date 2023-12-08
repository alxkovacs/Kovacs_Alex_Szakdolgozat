import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:application/model/product_model.dart';

class ProductsScreenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ProductModel>> fetchProducts(String searchTerm) {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream;
    final lowercaseSearchTerm = searchTerm.toLowerCase();

    if (lowercaseSearchTerm.isNotEmpty) {
      stream = _firestore
          .collection('products')
          .where('name_lowercase', isGreaterThanOrEqualTo: lowercaseSearchTerm)
          .where('name_lowercase',
              isLessThanOrEqualTo: '${lowercaseSearchTerm}\uf8ff')
          .snapshots();
    } else {
      stream = _firestore.collection('products').snapshots();
    }

    return stream.map((snapshot) => snapshot.docs.map((doc) {
          return ProductModel.fromProductDTO(doc);
        }).toList());
  }
}
