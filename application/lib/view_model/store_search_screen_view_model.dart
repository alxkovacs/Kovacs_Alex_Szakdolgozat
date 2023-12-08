import 'package:application/model/store_model.dart';
import 'package:application/service/store_search_service.dart';
import 'package:flutter/material.dart';

class StoreSearchScreenViewModel extends ChangeNotifier {
  final StoreSearchService _storeSearchService = StoreSearchService();
  List<StoreModel> searchResults = [];
  String lastSearchTerm = '';
  bool isInitialLoaded = false;

  void resetAndLoadInitialStores() async {
    lastSearchTerm = '';
    _storeSearchService.getInitialStores().listen((stores) {
      searchResults = stores;
      notifyListeners();
    });
  }

  void loadInitialStores() {
    if (!isInitialLoaded) {
      _storeSearchService.getInitialStores().listen((stores) {
        searchResults = stores;
        notifyListeners();
      });
      isInitialLoaded = true;
    }
  }

  Future<void> performSearch(String query) async {
    lastSearchTerm = query;

    if (query.isEmpty) {
      loadInitialStores();
      return;
    }

    searchResults = await _storeSearchService.searchStores(query);
    notifyListeners();
  }
}
