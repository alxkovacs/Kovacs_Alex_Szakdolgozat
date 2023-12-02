import 'package:application/model/favorite_model.dart';
import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesScreenViewModel extends ChangeNotifier {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  List<String> _favoriteStores = [];

  List<String> get favoriteStores => _favoriteStores;

  FavoritesScreenViewModel({FirebaseFirestore? db, FirebaseAuth? auth})
      : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance {
    loadFavoriteStores();
  }

  void loadFavoriteStores() async {
    String userId = _auth.currentUser?.uid ?? '';
    var snapshot = await _db
        .collection('favoriteStores')
        .where('userId', isEqualTo: userId)
        .get();

    _favoriteStores =
        snapshot.docs.map((doc) => doc['storeId'] as String).toList();
    notifyListeners();
  }

  Stream<List<FavoriteModel>> getFavoritesStream() {
    String userId = _auth.currentUser?.uid ?? '';
    return _db
        .collection('favoriteProducts')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((favoritesSnapshot) async {
      List<FavoriteModel> favorites = [];
      for (var favoriteDoc in favoritesSnapshot.docs) {
        String productId = favoriteDoc.get('productId');
        var productSnapshot =
            await _db.collection('products').doc(productId).get();
        favorites.add(FavoriteModel.fromDocument(productSnapshot));
      }
      return favorites;
    });
  }

  // Stream a kedvenc áruházak lekérdezéséhez
  Stream<List<String>> getFavoriteStoresStream() {
    String userId = _auth.currentUser?.uid ?? '';
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

  void resetFavorites() {
    _favoriteStores = [];
    notifyListeners();
  }
}
