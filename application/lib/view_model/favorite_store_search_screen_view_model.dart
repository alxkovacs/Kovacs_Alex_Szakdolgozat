import 'dart:async';

import 'package:application/utils/translation_en.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteStoreScreenViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final String userId;
  List<String> _favoriteStores = [];
  List<Map<String, String>> searchResults = [];
  StreamSubscription<QuerySnapshot>? storeSubscription;

  FavoriteStoreScreenViewModel() {
    // Figyeljük a felhasználói állapot változásait
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        userId = user.uid;
        loadInitialStoresAsync(); // Betöltjük az összes boltot
        loadFavoriteStores(); // Betöltjük a kedvenc boltokat
      }
    });
  }

  List<String> get favoriteStores => _favoriteStores;

  void loadFavoriteStores() {
    _db
        .collection('favoriteStores')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      _favoriteStores =
          snapshot.docs.map((doc) => doc.data()['storeId'] as String).toList();
      notifyListeners();
    });
  }

  Future<void> toggleFavoriteStatus(String storeId) async {
    if (_favoriteStores.contains(storeId)) {
      await removeStoreFromFavorites(storeId);
    } else {
      await addStoreToFavorites(storeId);
    }
    notifyListeners();
  }

  Future<void> addStoreToFavorites(String storeId) async {
    await _db.collection('favoriteStores').add({
      'storeId': storeId,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _favoriteStores.add(storeId);
    loadFavoriteStores(); // Frissítse a listát a hozzáadás után
    notifyListeners();
  }

  Future<void> removeStoreFromFavorites(String storeId) async {
    final querySnapshot = await _db
        .collection('favoriteStores')
        .where('storeId', isEqualTo: storeId)
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in querySnapshot.docs) {
      await _db.collection('favoriteStores').doc(doc.id).delete();
    }

    _favoriteStores.remove(storeId);
    loadFavoriteStores(); // Frissítse a listát a hozzáadás után
    notifyListeners();
  }

  Future<void> loadInitialStoresAsync() async {
    storeSubscription = _db.collection('stores').snapshots().listen(
      (snapshot) {
        var allStores = snapshot.docs.map((doc) {
          var data = doc.data();
          String id = doc.id;
          String name = data['name'] as String? ?? TranslationEN.unknownStore;
          bool isFavorite = _favoriteStores.contains(id);

          return {
            'id': id,
            'name': name,
            'isFavorite': isFavorite,
          };
        }).toList();

        // Rendezzük a listát úgy, hogy a kedvencek elől legyenek
        allStores.sort((a, b) {
          bool isFavoriteA = a['isFavorite'] as bool;
          bool isFavoriteB = b['isFavorite'] as bool;
          return isFavoriteA == isFavoriteB ? 0 : (isFavoriteA ? -1 : 1);
        });

        searchResults = allStores.map((store) {
          return {
            'id': store['id'] as String,
            'name': store['name'] as String,
          };
        }).toList();

        notifyListeners();
      },
    );
  }

  Future<void> performSearch(String query) async {
    if (query.isEmpty) {
      loadInitialStoresAsync();
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('stores')
          .where('name_lowercase', isGreaterThanOrEqualTo: lowercaseQuery)
          .where('name_lowercase',
              isLessThanOrEqualTo: lowercaseQuery + '\uf8ff')
          .get();

      searchResults = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] as String,
        };
      }).toList();
    } catch (e) {
      // Kezeld a lehetséges kivételeket, például hálózati hibákat
      print('${TranslationEN.error}: $e');
    }

    notifyListeners();
  }

  void updateSearchResults(QuerySnapshot snapshot) {
    var allStores = snapshot.docs.map((doc) {
      var data = doc.data()
          as Map<String, dynamic>; // Biztonságosabb típuskényszerítés
      String id = doc.id;
      String name = data['name'] as String? ?? TranslationEN.unknownStore;
      bool isFavorite =
          _favoriteStores.contains(id); // Itt ellenőrizzük, hogy kedvenc-e

      return {
        'id': id,
        'name': name,
        'isFavorite': isFavorite,
      };
    }).toList();

    // Rendezzük a listát úgy, hogy a kedvencek elől legyenek
    allStores.sort((a, b) {
      bool isFavoriteA =
          a['isFavorite'] as bool; // Biztosítsuk, hogy ez egy bool
      bool isFavoriteB =
          b['isFavorite'] as bool; // Biztosítsuk, hogy ez egy bool
      if (isFavoriteA && !isFavoriteB) {
        return -1;
      } else if (!isFavoriteA && isFavoriteB) {
        return 1;
      }
      return 0;
    });

    searchResults = allStores.map((store) {
      // Használj explicit típuskényszerítést a 'as String' használatával,
      // vagy az elvárt típusra vonatkozó biztonságos alapértelmezett értéket.
      String id = store['id'] as String? ?? '';
      String name = store['name'] as String? ?? TranslationEN.unknownStore;

      return {
        'id': id,
        'name': name,
      };
    }).toList();

    notifyListeners();
  }

  @override
  void dispose() {
    storeSubscription?.cancel();
    super.dispose();
  }
}
