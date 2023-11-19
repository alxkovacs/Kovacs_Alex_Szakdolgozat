import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreSearchScreen extends StatefulWidget {
  @override
  _StoreSearchScreenState createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends State<StoreSearchScreen> {
  List<String> searchResults = [];
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
    // Mentsd el a StreamSubscription-t, hogy később le tudd iratkozni róla
    storeSubscription = FirebaseFirestore.instance
        .collection('stores')
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() {
          searchResults =
              snapshot.docs.map((doc) => doc['name'] as String).toList();
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
      lastSearchTerm = query; // Eredeti, nem módosított keresőszöveget tárolja
      searchResults =
          querySnapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                if (searchResults.isEmpty) {
                  return ListTile(
                    // title: Text('Nincs találat: ' + lastSearchTerm),
                    title: Text(capitalize(lastSearchTerm)),
                    onTap: () {
                      Navigator.pop(context, capitalize(lastSearchTerm));
                      FocusScope.of(context)
                          .unfocus(); // Ez zárja be a billentyűzetet
                    },
                  );
                }
                return ListTile(
                  title: Text(searchResults[index]),
                  onTap: () {
                    Navigator.pop(context, searchResults[index]);
                    FocusScope.of(context)
                        .unfocus(); // Ez zárja be a billentyűzetet
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
