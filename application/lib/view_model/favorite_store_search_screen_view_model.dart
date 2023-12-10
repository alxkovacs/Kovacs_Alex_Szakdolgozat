import 'package:application/service/favorite_store_search_screen_service.dart';
import 'package:application/model/favorite_store_dto.dart';
import 'package:application/model/favorite_store_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteStoreScreenViewModel extends ChangeNotifier {
  final FavoriteStoreSearchScreenService _favoriteService =
      FavoriteStoreSearchScreenService();
  List<FavoriteStoreModel> searchResults = [];
  List<String> favoriteStores = [];
  late final String userId;

  FavoriteStoreScreenViewModel() {
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    loadInitialStoresAsync();
    loadFavoriteStores();
  }

  Future<void> loadFavoriteStores() async {
    favoriteStores = await _favoriteService.getFavoriteStores(userId);
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String storeId) async {
    if (favoriteStores.contains(storeId)) {
      await _favoriteService.removeStoreFromFavorites(userId, storeId);
    } else {
      await _favoriteService.addStoreToFavorites(userId, storeId);
    }
    await loadFavoriteStores();
  }

  Future<void> loadInitialStoresAsync() async {
    _favoriteService.getStoresStream(userId).listen((storesDTO) {
      searchResults = _sortStoresByFavorites(storesDTO);
      notifyListeners();
    });
  }

  Future<void> performSearch(String query) async {
    if (query.isEmpty) {
      await loadInitialStoresAsync();
    } else {
      var storesDTO = await _favoriteService.searchStores(userId, query);
      searchResults = _sortStoresByFavorites(storesDTO);
      notifyListeners();
    }
  }

  List<FavoriteStoreModel> _sortStoresByFavorites(
      List<FavoriteStoreDTO> storesDTO) {
    return storesDTO.map((dto) {
      bool isFavorite = favoriteStores.contains(dto.id);
      return FavoriteStoreModel.fromDTO(dto, isFavorite);
    }).toList()
      ..sort((a, b) {
        if (a.isFavorite && !b.isFavorite) return -1;
        if (!a.isFavorite && b.isFavorite) return 1;
        return 0;
      });
  }
}
