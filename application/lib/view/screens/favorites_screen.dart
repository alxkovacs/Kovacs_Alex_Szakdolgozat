import 'dart:async';

import 'package:application/model/favorite.dart';
import 'package:application/providers/favorite_stores_provider.dart';
import 'package:application/services/database_service.dart';
import 'package:application/utils/colors.dart';
import 'package:application/view/screens/favorite_store_search_screen.dart';
import 'package:application/view/widgets/favorite_item_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final DatabaseService databaseService = DatabaseService();

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    // Feliratkozás a felhasználói állapot változásainak figyelésére
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // A felhasználó kijelentkezett
        // Itt kellene resetelni a FavoriteStoresNotifier-t
        ref.read(favoriteStoresProvider.notifier).reset();
      } else {
        // A felhasználó bejelentkezett
        // Itt kellene frissíteni a FavoriteStoresNotifier-t az új userID-val
        ref.read(favoriteStoresProvider.notifier).update(user.uid);
      }
    });
  }

  @override
  void dispose() {
    // Leiratkozás a felhasználói állapot változásainak figyeléséről, amikor a widget már nem aktív
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<List<String>> getStoreNamesById(List<String> storeIds) async {
    List<String> storeNames = [];
    for (String id in storeIds) {
      // Itt hajtsa végre a lekérdezést az adatbázis szolgáltatáshoz, hogy lekérje az áruház nevét az ID alapján.
      var storeName = await databaseService.getStoreNameById(id);
      storeNames.add(storeName);
    }
    return storeNames;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // Az új szín.
    ));
    final favoriteStores = ref.watch(favoriteStoresProvider);

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            'Kedvencek',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        body: Center(
          child:
              Text('Kérlek jelentkezz be, hogy megtekinthesd a kedvenceidet.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Kedvencek',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Áruházak',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Itt jönnek az áruházak dummy listái
            FutureBuilder<List<String>>(
              future: getStoreNamesById(favoriteStores),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColor.mainColor,
                        ),
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height:
                          50, // vagy bármely más magasság, amely megfelel a dizájn követelményeinek
                      child: Center(child: Text('Nincsenek kedvenc áruházak.')),
                    ),
                  );
                }

                List<String> storeNames = snapshot.data!;

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                        title: Text(storeNames[index]), // Az áruház neve
                        leading: Text('🏪', style: TextStyle(fontSize: 30)),
                      );
                    },
                    childCount: storeNames.length,
                  ),
                );
              },
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Kedvenc áruház hozzáadása',
                      style: TextStyle(
                          color: Colors
                              .black, // Az alkalmazás színsémájához illeszkedő szín
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    // leading: Icon(
                    //   Icons.add,
                    //   color: AppColor.mainColor,
                    // ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FavoriteStoreSearchScreen()), // Az új képernyőd widget osztálya
                      );
                    },
                  ),
                  Divider(), // Elválasztó vonal a listaelemek között
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Termékek',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Itt jönnek a kedvenc termékek
            StreamBuilder<List<Favorite>>(
              stream: databaseService.getFavoritesStream(userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColor.mainColor,
                        ),
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(child: Text('No favorites yet.')),
                  );
                }

                var favorites = snapshot.data!;

                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final favoriteItem = favorites[index];
                      return FavoriteItemCard(favorite: favoriteItem);
                    },
                    childCount: favorites.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
