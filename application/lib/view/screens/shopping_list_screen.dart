import 'package:application/model/product_model.dart';
import 'package:application/providers/shopping_list_view_model_provider.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/shopping_list_item_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  late Future<List<dynamic>> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    _loadingFuture = Future.wait([
      ref.read(shoppingListViewModelProvider).getFavoriteStoresTotal(userId),
      ref.read(shoppingListViewModelProvider).getCheapestStoreTotal(userId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(shoppingListViewModelProvider);
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          TranslationEN.shoppingList,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: viewModel.getShoppingListStream(userId),
        builder: (context, productSnapshot) {
          if (productSnapshot.connectionState == ConnectionState.waiting) {
            return const CustomCircularProgressIndicator();
          } else if (productSnapshot.hasError) {
            return Center(
                child:
                    Text('${TranslationEN.error}: ${productSnapshot.error}'));
          } else if (productSnapshot.hasData) {
            final products = productSnapshot.data!;

            return FutureBuilder<List<dynamic>>(
              future: _loadingFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomCircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('${TranslationEN.error}: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final favoriteStoresTotals =
                      snapshot.data![0] as List<Map<String, dynamic>>;
                  final cheapestStoreTotal =
                      snapshot.data![1] as Map<String, dynamic>;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ShoppingListItemCard(
                              onRemove: () async {
                                await viewModel.removeProductFromShoppingList(
                                    userId, product.id);
                                _initializeData(); // Frissítjük a kedvenc boltok és legolcsóbb bolt adatokat
                              },
                              id: product.id,
                              name: product.product,
                              categoryName: product.category,
                              emoji: product.emoji,
                            );
                          },
                        ),
                        // Itt jelenítsd meg a kedvenc boltok és legolcsóbb bolt adatait...
                        const Divider(),
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 15, bottom: 0, left: 10, right: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              TranslationEN.favoriteStores,
                              style: Styles.shoppingListSubtitle,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: favoriteStoresTotals.length,
                          itemBuilder: (context, index) {
                            final storeTotal = favoriteStoresTotals[index];
                            return ListTile(
                              title: Text(
                                storeTotal['storeName'] ??
                                    TranslationEN
                                        .unknownStore, // Alapértelmezett érték, ha null
                                style: Styles.shoppingListStoreName,
                              ),
                              trailing: Text(
                                '${storeTotal['total'] ?? '0'} ${TranslationEN.currencyHUF}', // Alapértelmezett érték, ha null
                                style: Styles.shoppingListPrice,
                              ),
                            );
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 15, bottom: 0, left: 10, right: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              TranslationEN.cheapestStore,
                              style: Styles.shoppingListSubtitle,
                            ),
                          ),
                        ),
                        // A legolcsóbb bolt adatai
                        ListTile(
                          title: Text(
                            cheapestStoreTotal['storeName'] ??
                                TranslationEN
                                    .noStoreAvailable, // Alapértelmezett érték, ha null
                            style: Styles.shoppingListStoreName,
                          ),
                          trailing: Text(
                            cheapestStoreTotal['total'] != null
                                ? "${cheapestStoreTotal['total']} ${TranslationEN.currencyHUF}"
                                : TranslationEN
                                    .noData, // Kezeljük a null értéket
                            style: Styles.shoppingListPrice,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text(TranslationEN.noAdditionalData);
                }
              },
            );
          } else {
            return const Text(TranslationEN.emptyShoppingList);
          }
        },
      ),
    );
  }
}
