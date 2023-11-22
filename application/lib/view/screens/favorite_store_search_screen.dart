import 'dart:async';

import 'package:application/providers/favorite_stores_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteStoreSearchScreen extends ConsumerStatefulWidget {
  @override
  _FavoriteStoreSearchScreenState createState() =>
      _FavoriteStoreSearchScreenState();
}

class _FavoriteStoreSearchScreenState
    extends ConsumerState<FavoriteStoreSearchScreen> {
  List<Map<String, String>> searchResults = [];
  String lastSearchTerm = '';
  StreamSubscription<QuerySnapshot>? storeSubscription;

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  void initState() {
    super.initState();
    loadInitialStores();
  }

  void loadInitialStores() {
    storeSubscription = FirebaseFirestore.instance
        .collection('stores')
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() {
          // Módosítsuk a searchResults-ot, hogy Map-eket tároljon
          searchResults = snapshot.docs.map((doc) {
            return {
              'id': doc.id, // Az áruház dokumentumának azonosítója
              'name': doc['name'] as String, // Az áruház neve
            };
          }).toList();
        });
      }
    });
  }

  @override
  void dispose() {
    // Iratkozz le, amikor a State törlésre kerül
    storeSubscription?.cancel();
    super.dispose();
  }

  void performSearch(String query) async {
    final lowercaseQuery = query.toLowerCase();
    if (lowercaseQuery.isEmpty) {
      loadInitialStores();
      return;
    }
    final querySnapshot = await FirebaseFirestore.instance
        .collection('stores')
        .where('name_lowercase', isGreaterThanOrEqualTo: lowercaseQuery)
        .where('name_lowercase', isLessThanOrEqualTo: lowercaseQuery + '\uf8ff')
        .get();

    setState(() {
      lastSearchTerm = query;
      // Módosítsuk a searchResults-ot, hogy Map-eket tároljon
      searchResults = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] as String,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> favoriteStores = ref.watch(favoriteStoresProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Válasszon helyszínt'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              onChanged: (value) => performSearch(value.toLowerCase()),
              decoration: InputDecoration(
                isDense: true, // Added this
                contentPadding: EdgeInsets.all(0),
                hintText: 'Keresés a termékek között...',
                hintStyle: TextStyle(color: Color.fromRGBO(67, 153, 182, 0.75)),
                filled: true, // Ez engedélyezi a háttérszín beállítását
                fillColor: const Color.fromRGBO(
                    67, 153, 182, 0.20), // A háttérszín beállítása kék színre
                // Adj hozzá egy tiszta gombot a keresősávhoz
                // suffixIcon: IconButton(
                //   icon: Icon(
                //     Icons.clear,
                //     color: Color.fromRGBO(67, 153, 182, 1.0),
                //   ),
                //   onPressed: () => _searchController.clear(),
                // ),
                // Adj hozzá egy kereső ikont vagy gombot a keresősávhoz
                prefixIcon: Icon(
                  Icons.search,
                  color: Color.fromRGBO(67, 153, 182, 1.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: const Color.fromRGBO(67, 153, 182, 0.15),
                  ), // A szegély színe piros
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: const Color.fromRGBO(67, 153, 182, 0.15),
                  ), // A szegély színe piros
                ),
                // Beállítja a fókuszált szegély színét is pirosra
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: const Color.fromRGBO(67, 153, 182, 0.15),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.isNotEmpty ? searchResults.length : 1,
              itemBuilder: (context, index) {
                // Ha nincs találat, akkor az üres lista logikája
                if (searchResults.isEmpty) {
                  return ListTile(
                    title: Text('Nem található a keresett áruház.'),
                  );
                }

                // Mivel a searchResults most már Map-eket tartalmaz, így hivatkozunk rájuk
                final storeMap = searchResults[index];
                final storeId = storeMap['id']!;
                final storeName = storeMap['name']!;
                final isFavorited = favoriteStores.contains(storeId);

                return ListTile(
                  title: Text(storeName),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : null,
                    ),
                    onPressed: () {
                      // Kedvenc állapotának megváltoztatása
                      final notifier =
                          ref.read(favoriteStoresProvider.notifier);
                      notifier.toggleFavoriteStatus(storeId);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
