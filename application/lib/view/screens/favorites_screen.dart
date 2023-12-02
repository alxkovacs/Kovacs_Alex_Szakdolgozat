import 'dart:async';

import 'package:application/model/favorite_model.dart';
import 'package:application/providers/favorites_view_model.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/favorite_store_search_screen.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/favorite_item_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    // Feliratkozás a felhasználói állapot változásainak figyelésére
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        ref.read(favoritesViewModelProvider).resetFavorites();
      } else {
        ref.read(favoritesViewModelProvider).loadFavoriteStores();
      }
    });
  }

  @override
  void dispose() {
    // Leiratkozás a felhasználói állapot változásainak figyeléséről, amikor a widget már nem aktív
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // Az új szín.
    ));
    final viewModel = ref.watch(favoritesViewModelProvider);

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            TranslationEN.favorites,
            style: Styles.favoritesScreenTitle,
          ),
        ),
        body: const Center(
          child: Text(TranslationEN.loginToSeeYourFavorites),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          TranslationEN.favorites,
          style: Styles.favoritesScreenTitle,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  TranslationEN.stores,
                  style: Styles.favoritesScreenSubtitle,
                ),
              ),
            ),
            // Itt jönnek az áruházak listái
            StreamBuilder<List<String>>(
              stream: viewModel.getFavoriteStoresStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                      child: CustomCircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: SizedBox(
                      height:
                          50, // vagy bármely más magasság, amely megfelel a dizájn követelményeinek
                      child:
                          Center(child: Text(TranslationEN.noFavoriteStores)),
                    ),
                  );
                }

                List<String> storeNames = snapshot.data!;

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                        title: Text(storeNames[index]), // Az áruház neve
                        leading:
                            const Text('🏪', style: TextStyle(fontSize: 30)),
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
                    title: const Text(
                      TranslationEN.addFavoriteStore,
                      style: TextStyle(
                          color: Colors
                              .black, // Az alkalmazás színsémájához illeszkedő szín
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FavoriteStoreSearchScreen(),
                        ), // Az új képernyőd widget osztálya
                      );
                    },
                  ),
                  const Divider(), // Elválasztó vonal a listaelemek között
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  TranslationEN.products,
                  style: Styles.favoritesScreenSubtitle,
                ),
              ),
            ),
            // Itt jönnek a kedvenc termékek
            StreamBuilder<List<FavoriteModel>>(
              stream: viewModel.getFavoritesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: CustomCircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text(TranslationEN.noFavoritesYet)),
                  );
                }

                var favorites = snapshot.data!;

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
