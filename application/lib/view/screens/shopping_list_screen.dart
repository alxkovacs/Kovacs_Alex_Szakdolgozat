import 'package:application/model/product_model.dart';
import 'package:application/providers/shopping_list_view_model_provider.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/shopping_list_item_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/shopping_list_item_card.dart';
import 'package:application/view_model/shopping_list_screen_view_model.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final shoppingListScreenViewModel =
        Provider.of<ShoppingListScreenViewModel>(context, listen: false);
    await shoppingListScreenViewModel.updateShoppingListItems(userId);
    await shoppingListScreenViewModel.updateCheapestStoreTotal(userId);
  }

  @override
  Widget build(BuildContext context) {
    final shoppingListScreenViewModel =
        Provider.of<ShoppingListScreenViewModel>(context);
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
      body: FutureBuilder(
        future: _initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomCircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
                child: Text('${TranslationEN.error}: ${snapshot.error}'));
          } else {
            if (shoppingListScreenViewModel.shoppingListItems.isEmpty) {
              return const Center(
                child: Text(TranslationEN.emptyShoppingList),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          shoppingListScreenViewModel.shoppingListItems.length,
                      itemBuilder: (context, index) {
                        final product = shoppingListScreenViewModel
                            .shoppingListItems[index];
                        return ShoppingListItemCard(
                          productModel: product,
                          onRemove: () async {
                            await shoppingListScreenViewModel
                                .removeProductFromShoppingList(
                                    userId, product.id);
                            _initializationFuture = _initializeData();
                          },
                        );
                      },
                    ),
                    const Divider(),
                    _buildFavoriteStoresSection(shoppingListScreenViewModel),
                    _buildCheapestStoreSection(shoppingListScreenViewModel),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildFavoriteStoresSection(ShoppingListScreenViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 20),
          child: Text(
            TranslationEN.favoriteStores,
            style: Styles.shoppingListSubtitle,
          ),
        ),
        ...viewModel.getFavoriteStoresTotals.map((storeTotal) => ListTile(
              title: Text(
                storeTotal['storeName'],
                style: Styles.shoppingListStoreName,
              ),
              trailing: Text(
                '${storeTotal['total']} ${TranslationEN.currencyHUF}',
                style: Styles.shoppingListPrice,
              ),
            )),
      ],
    );
  }

  Widget _buildCheapestStoreSection(ShoppingListScreenViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 20),
          child: Text(
            TranslationEN.cheapestStore,
            style: Styles.shoppingListSubtitle,
          ),
        ),
        ListTile(
          title: Text(
            viewModel.cheapestStoreTotal['storeName'] ??
                TranslationEN.unknownStore,
            style: Styles.shoppingListStoreName,
          ),
          trailing: Text(
            '${viewModel.cheapestStoreTotal['total'] ?? '0'} ${TranslationEN.currencyHUF}',
            style: Styles.shoppingListPrice,
          ),
        ),
      ],
    );
  }
}
