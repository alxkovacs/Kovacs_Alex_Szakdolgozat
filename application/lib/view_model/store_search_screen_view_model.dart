import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoreSearchScreenViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<String> searchResults = [];
  String lastSearchTerm = '';
  bool isInitialLoaded = false;

  void resetAndLoadInitialStores() {
    lastSearchTerm = '';
    // Újra betöltjük az összes áruházat
    _db.collection('stores').snapshots().listen((snapshot) {
      searchResults =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      notifyListeners();
    });
  }

  void loadInitialStores() {
    if (!isInitialLoaded) {
      _db.collection('stores').snapshots().listen((snapshot) {
        searchResults =
            snapshot.docs.map((doc) => doc['name'] as String).toList();
        notifyListeners();
      });
      isInitialLoaded = true;
    }
  }

  Future<void> performSearch(String query) async {
    lastSearchTerm = query; // Itt tároljuk el a legutóbbi keresési szöveget

    if (query.isEmpty) {
      loadInitialStores();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final querySnapshot = await _db
        .collection('stores')
        .where('name_lowercase', isGreaterThanOrEqualTo: lowercaseQuery)
        .where('name_lowercase', isLessThanOrEqualTo: lowercaseQuery + '\uf8ff')
        .get();

    searchResults =
        querySnapshot.docs.map((doc) => doc['name'] as String).toList();
    notifyListeners();
  }
}
