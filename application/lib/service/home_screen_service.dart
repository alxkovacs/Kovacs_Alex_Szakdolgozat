import 'package:application/model/product_dto.dart';
import 'package:application/model/user_dto.dart';
import 'package:application/utils/translation_en.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductDTO>> fetchTopViewedProducts() async {
    var snapshot = await _firestore
        .collection('products')
        .orderBy('viewCount', descending: true)
        .limit(9)
        .get();

    return snapshot.docs
        .map((doc) => ProductDTO.fromFirebaseJson(doc.data(), doc.id))
        .toList();
  }

  Future<UserDTO> fetchUserName(String userId) async {
    try {
      var docSnapshot = await _firestore.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        return UserDTO.fromFirebaseJson(
            docSnapshot.data() as Map<String, dynamic>);
      } else {
        return UserDTO(
            firstName: TranslationEN.noData, email: '', password: '');
      }
    } catch (e) {
      return UserDTO(firstName: TranslationEN.error, email: '', password: '');
    }
  }

  Future<int> getDocumentCount(String collectionPath) async {
    final querySnapshot = await _firestore.collection(collectionPath).get();
    return querySnapshot.docs.length;
  }
}
