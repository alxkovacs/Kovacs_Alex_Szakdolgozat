import 'package:application/model/store_model.dart';
import 'package:application/service/store_search_service.dart';
import 'package:flutter/material.dart';

class StoreSearchScreenViewModel extends ChangeNotifier {
  final StoreSearchService _storeSearchService = StoreSearchService();
  List<StoreModel> searchResults = [];
  String lastSearchTerm = '';
  bool isInitialLoaded = false;

  void loadInitialStores() {
    if (!isInitialLoaded) {
      _storeSearchService.getInitialStores().listen((storeDTOs) {
        searchResults =
            storeDTOs.map((dto) => StoreModel.fromDTO(dto)).toList();
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

    var storeDTOs = await _storeSearchService.searchStores(query);
    searchResults = storeDTOs.map((dto) => StoreModel.fromDTO(dto)).toList();
    notifyListeners();
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s.replaceFirst(s[0], s[0].toUpperCase());
  }
}
