import 'package:application/providers/shopping_list_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/view/widgets/product_card.dart';
import 'package:application/view/widgets/savings_card.dart';
import 'package:application/view/widgets/shopping_list_card.dart';
import 'package:application/view/widgets/shopping_list_item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    _loadingFuture = Future.wait([
      ref.read(shoppingListProvider).getFavoriteStoresTotal(userId),
      ref.read(shoppingListProvider).getCheapestStoreTotal(userId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListAsyncValue = ref.watch(shoppingListStreamProvider);
    final userId = FirebaseAuth
        .instance.currentUser!.uid; // Bejelentkezett felhasználó UID-je

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Bevásárlólista',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColor.mainColor,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // return Center(child: Text('Hiba történt: ${snapshot.error}'));
            // Ha hiba történt, megvizsgáljuk, hogy mi volt a hiba oka
            if (snapshot.error.toString().contains('No element')) {
              // Specifikus hibaüzenet, ha a felhasználónak nincs bevásárlólistája
              return Center(child: Text('Üres bevásárlólista'));
            } else {
              // Egyéb hibák kezelése
              return Center(child: Text('Hiba történt: ${snapshot.error}'));
            }
          } else if (snapshot.hasData) {
            final favoriteStoresTotals =
                snapshot.data![0] as List<Map<String, dynamic>>;
            final cheapestStoreTotal =
                snapshot.data![1] as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Column(
                children: [
                  shoppingListAsyncValue.when(
                    data: (products) {
                      // Ha vannak adatok, akkor megjelenítjük őket
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          // Itt használd a widget-edet, ami megjeleníti a termékeket
                          return ShoppingListItemCard(
                            onRemove: () async {
                              // Először megszerzzük a felhasználó bevásárlólistájának azonosítóját
                              final userShoppingListSnapshot =
                                  await FirebaseFirestore.instance
                                      .collection('shoppingLists')
                                      .where('userId',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .limit(1)
                                      .get();

                              if (userShoppingListSnapshot.docs.isEmpty) {
                                // Kezeljük a hibát: a felhasználónak nincs bevásárlólistája
                                return;
                              }

                              final shoppingListId =
                                  userShoppingListSnapshot.docs.first.id;

                              await ref
                                  .read(shoppingListProvider)
                                  .removeProductFromShoppingList(
                                      shoppingListId, product.id);
                              // Frissítjük a UI-t a bevásárlólista újratöltésével
                              ref.refresh(shoppingListStreamProvider);
                              _initializeData(); // Ez újraindítja a Future.wait() hívást, és frissíti az összegzett összegeket
                            },
                            id: product.id,
                            name: product.name,
                            categoryName: product.categoryName,
                            emoji: product.categoryEmoji,
                          );
                        },
                      );
                    },
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColor.mainColor,
                        ),
                      ),
                    ),
                    error: (error, stack) => Text('Hiba történt: $error'),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),

                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 0, left: 10, right: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Kedvenc áruház(ak)',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: favoriteStoresTotals.length,
                    itemBuilder: (context, index) {
                      final storeTotal = favoriteStoresTotals[index];
                      return ListTile(
                        title: Text(
                          storeTotal['storeName'] ??
                              'Ismeretlen áruház', // Alapértelmezett érték, ha null
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.65)),
                        ),
                        trailing: Text(
                          '${storeTotal['total'] ?? '0'} Ft', // Alapértelmezett érték, ha null
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 0, left: 10, right: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Legolcsóbb áruház',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // A legolcsóbb bolt adatai
                  ListTile(
                    title: Text(
                      cheapestStoreTotal['storeName'] ??
                          'Nincs elérhető áruház', // Alapértelmezett érték, ha null
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.65)),
                    ),
                    trailing: Text(
                      cheapestStoreTotal['total'] != null
                          ? "${cheapestStoreTotal['total']} Ft"
                          : 'Nincs adat', // Kezeljük a null értéket
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  // Egyéb widgetek
                ],
              ),
            );
          } else {
            return Center(child: Text('Üres bevásárlólista'));
          }
        },
      ),
    );
  }
}
