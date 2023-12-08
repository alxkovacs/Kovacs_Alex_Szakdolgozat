import 'package:application/model/store_dto.dart';
import 'package:application/model/store_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreSearchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<StoreModel>> getInitialStores() {
    return _db.collection('stores').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        StoreDTO storeDTO = StoreDTO.fromFirestore(doc);
        return StoreModel.fromDTO(storeDTO);
      }).toList();
    });
  }

  Future<List<StoreModel>> searchStores(String query) async {
    final lowercaseQuery = query.toLowerCase();
    final querySnapshot = await _db
        .collection('stores')
        .where('name_lowercase', isGreaterThanOrEqualTo: lowercaseQuery)
        .where('name_lowercase', isLessThanOrEqualTo: lowercaseQuery + '\uf8ff')
        .get();

    return querySnapshot.docs.map((doc) {
      StoreDTO storeDTO = StoreDTO.fromFirestore(doc);
      return StoreModel.fromDTO(storeDTO);
    }).toList();
  }
}
