import 'package:application/model/favorite_store_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteStoreSearchScreenService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<FavoriteStoreDTO>> getStoresStream(String userId) async* {
    var favoriteStoresSnapshot = await _db
        .collection('favoriteStores')
        .where('userId', isEqualTo: userId)
        .get();
    List<String> favoriteStoreIds = favoriteStoresSnapshot.docs
        .map((doc) => doc.data()['storeId'] as String)
        .toList();

    yield* _db.collection('stores').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        bool isFavorite = favoriteStoreIds.contains(doc.id);
        return FavoriteStoreDTO.fromFirestore(doc, isFavorite);
      }).toList();
    });
  }

  Future<List<String>> getFavoriteStores(String userId) async {
    var snapshot = await _db
        .collection('favoriteStores')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((doc) => doc.data()['storeId'] as String).toList();
  }

  Future<void> addStoreToFavorites(String userId, String storeId) async {
    await _db.collection('favoriteStores').add({
      'storeId': storeId,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeStoreFromFavorites(String userId, String storeId) async {
    final querySnapshot = await _db
        .collection('favoriteStores')
        .where('storeId', isEqualTo: storeId)
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in querySnapshot.docs) {
      await _db.collection('favoriteStores').doc(doc.id).delete();
    }
  }

  Future<List<FavoriteStoreDTO>> searchStores(
      String userId, String query) async {
    final lowercaseQuery = query.toLowerCase();
    final querySnapshot = await _db
        .collection('stores')
        .where('name_lowercase', isGreaterThanOrEqualTo: lowercaseQuery)
        .where('name_lowercase', isLessThanOrEqualTo: lowercaseQuery + '\uf8ff')
        .get();

    var favoriteStoresSnapshot = await _db
        .collection('favoriteStores')
        .where('userId', isEqualTo: userId)
        .get();
    List<String> favoriteStoreIds = favoriteStoresSnapshot.docs
        .map((doc) => doc.data()['storeId'] as String)
        .toList();

    return querySnapshot.docs.map((doc) {
      bool isFavorite = favoriteStoreIds.contains(doc.id);
      return FavoriteStoreDTO.fromFirestore(doc, isFavorite);
    }).toList();
  }
}
