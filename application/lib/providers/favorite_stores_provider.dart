import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Egy globális provider, amely a Firebase Firestore példányt adja vissza
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Egy provider, amely az aktuális felhasználó adatait adja vissza
final userProvider = Provider<User>((ref) {
  return FirebaseAuth.instance
      .currentUser!; // Biztosítani kell, hogy a felhasználó be legyen jelentkezve
});

final favoriteStoresProvider =
    StateNotifierProvider<FavoriteStoresNotifier, List<String>>((ref) {
  final user = ref.watch(userProvider);

  return FavoriteStoresNotifier(ref.watch(firebaseFirestoreProvider), user.uid);
});

class FavoriteStoresNotifier extends StateNotifier<List<String>> {
  final FirebaseFirestore _db;
  String userId;

  FavoriteStoresNotifier(this._db, this.userId) : super([]) {
    loadFavoriteStores();
  }

// Állapot visszaállítása az alapértelmezett üres listára
  void reset() {
    state = [];
  }

  StreamSubscription<QuerySnapshot>? _streamSubscription;
  bool _isActive = true;

  void update(String newUserId) {
    _isActive = true; // Az objektum újra aktívvá válik
    userId = newUserId;
    _streamSubscription
        ?.cancel(); // Leiratkozás az előző felhasználó streamjéről
    loadFavoriteStores(); // Újra betöltjük a kedvenceket az új felhasználó számára
  }

  @override
  void dispose() {
    _isActive = false; // A notifier már nem aktív
    _streamSubscription?.cancel(); // Leiratkozás a streamről
    super.dispose();
  }

  // Betöltjük a kedvenceket az aktuális felhasználó számára
  void loadFavoriteStores() {
    _streamSubscription?.cancel();
    _streamSubscription = _db
        .collection('favoriteStores')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      if (_isActive) {
        state = snapshot.docs.map((doc) => doc['storeId'] as String).toList();
      }
    });
  }

  // Amikor a notifier megszűnik, meg kell szakítanunk a stream hallgatózását
  // @override
  // void dispose() {
  //   _streamSubscription?.cancel();
  //   super.dispose();
  // }

  // void loadFavoriteStores() {
  //   _db
  //       .collection('favoriteStores')
  //       .where('userId', isEqualTo: userId)
  //       .snapshots()
  //       .listen((snapshot) {
  //     state = snapshot.docs.map((doc) => doc['storeId'] as String).toList();
  //   });
  // }

  // void loadFavoriteStores() {
  //   _db
  //       .collection('favoriteStores')
  //       .where('userId', isEqualTo: userId)
  //       .snapshots()
  //       .listen((snapshot) async {
  //     // Itt lekérjük az áruházak adatait az azonosítók alapján
  //     List<String> stores = [];
  //     for (var doc in snapshot.docs) {
  //       DocumentSnapshot storeSnapshot =
  //           await _db.collection('stores').doc(doc['storeId']).get();

  //       stores.add(storeSnapshot['storeId']);
  //     }
  //     state = stores;
  //   });
  // }

  Future<void> toggleFavoriteStatus(String storeId) async {
    if (state.contains(storeId)) {
      await removeStoreFromFavorites(storeId);
    } else {
      await addStoreToFavorites(storeId);
    }
  }

  Future<void> addStoreToFavorites(String storeId) async {
    await _db.collection('favoriteStores').add({
      'storeId': storeId,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
    // A state frissítése az új kedvenc hozzáadásával
    state = [...state, storeId];
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
    // A state frissítése a kedvenc eltávolításával
    state = state.where((id) => id != storeId).toList();
  }
}
