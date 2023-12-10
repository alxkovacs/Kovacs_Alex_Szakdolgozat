import 'package:application/model/store_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreSearchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<StoreDTO>> getInitialStores() {
    return _db.collection('stores').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => StoreDTO.fromFirestore(doc)).toList();
    });
  }

  Future<List<StoreDTO>> searchStores(String query) async {
    final lowercaseQuery = query.toLowerCase();
    final querySnapshot = await _db
        .collection('stores')
        .where('name_lowercase', isGreaterThanOrEqualTo: lowercaseQuery)
        .where('name_lowercase', isLessThanOrEqualTo: lowercaseQuery + '\uf8ff')
        .get();

    return querySnapshot.docs
        .map((doc) => StoreDTO.fromFirestore(doc))
        .toList();
  }
}
