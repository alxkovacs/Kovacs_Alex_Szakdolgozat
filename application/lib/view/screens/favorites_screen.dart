import 'dart:async';

import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/favorite_store_search_screen.dart';
import 'package:application/view/widgets/favorite_item_card.dart';
import 'package:application/view_model/favorites_screen_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Future.microtask(() =>
            Provider.of<FavoritesScreenViewModel>(context, listen: false)
                .resetFavorites());
      } else {
        Future.microtask(() =>
            Provider.of<FavoritesScreenViewModel>(context, listen: false)
                .loadFavorites());
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesScreenViewModel =
        Provider.of<FavoritesScreenViewModel>(context);

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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ListTile(
                    title: Text(favoritesScreenViewModel.favoriteStores[index]),
                    leading: const Text(
                      '🏪',
                      style: TextStyle(fontSize: 30),
                    ),
                  );
                },
                childCount: favoritesScreenViewModel.favoriteStores.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      TranslationEN.addFavoriteStore,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
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
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  TranslationEN.products,
                  style: Styles.favoritesScreenSubtitle,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 5,
                right: 5,
                bottom: 15,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final favoriteItem =
                        favoritesScreenViewModel.favorites[index];
                    return FavoriteItemCard(productModel: favoriteItem);
                  },
                  childCount: favoritesScreenViewModel.favorites.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
