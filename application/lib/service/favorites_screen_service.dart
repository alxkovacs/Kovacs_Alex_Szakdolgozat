import 'package:application/model/product_dto.dart';
import 'package:application/utils/translation_en.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesScreenService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ProductDTO>> getFavoritesStream(String userId) {
    return _db
        .collection('favoriteProducts')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((favoritesSnapshot) async {
      List<ProductDTO> favorites = [];
      for (var favoriteDoc in favoritesSnapshot.docs) {
        String productId = favoriteDoc.get('productId');
        var productSnapshot =
            await _db.collection('products').doc(productId).get();
        if (productSnapshot.exists) {
          var data = productSnapshot.data() as Map<String, dynamic>;
          favorites.add(ProductDTO.fromFirebaseJson(data, productSnapshot.id));
        }
      }
      return favorites;
    });
  }

  Stream<List<String>> getFavoriteStoresStream(String userId) {
    return _db
        .collection('favoriteStores')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((favoritesSnapshot) async {
      List<String> storeNames = [];
      for (var favorite in favoritesSnapshot.docs) {
        String storeId = favorite['storeId'] as String;
        var storeSnapshot = await _db.collection('stores').doc(storeId).get();
        String storeName = storeSnapshot.data()?['name'] as String? ??
            TranslationEN.unknownStore;
        storeNames.add(storeName);
      }
      return storeNames;
    });
  }
}
