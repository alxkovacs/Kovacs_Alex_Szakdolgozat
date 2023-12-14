import 'package:application/model/product_model.dart';
import 'package:application/service/favorites_screen_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesScreenViewModel extends ChangeNotifier {
  final FavoritesScreenService _favoriteService = FavoritesScreenService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ProductModel> favorites = [];
  List<String> favoriteStores = [];

  FavoritesScreenViewModel() {
    loadFavorites();
  }

  void loadFavorites() {
    String userId = _auth.currentUser?.uid ?? '';

    _favoriteService.getFavoritesStream(userId).listen((productDTOs) {
      favorites =
          productDTOs.map((dto) => ProductModel.fromProductDTO(dto)).toList();
      notifyListeners();
    });

    _favoriteService.getFavoriteStoresStream(userId).listen((stores) {
      favoriteStores = stores;
      notifyListeners();
    });
  }

  void resetFavorites() {
    favorites = [];
    favoriteStores = [];
    notifyListeners();
  }
}
