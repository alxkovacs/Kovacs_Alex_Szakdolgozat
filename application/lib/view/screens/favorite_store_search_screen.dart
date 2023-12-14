import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view_model/favorite_store_search_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteStoreSearchScreen extends StatefulWidget {
  const FavoriteStoreSearchScreen({super.key});

  @override
  _FavoriteStoreSearchScreenState createState() =>
      _FavoriteStoreSearchScreenState();
}

class _FavoriteStoreSearchScreenState extends State<FavoriteStoreSearchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoriteStoreScreenViewModel>(context, listen: false)
          .loadInitialStoresAsync();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteStoreSearchScreenviewModel =
        Provider.of<FavoriteStoreScreenViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(TranslationEN.chooseLocation),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              onChanged: (value) => favoriteStoreSearchScreenviewModel
                  .performSearch(value.toLowerCase()),
              decoration: Styles.storeSearchDecoration,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  favoriteStoreSearchScreenviewModel.searchResults.isNotEmpty
                      ? favoriteStoreSearchScreenviewModel.searchResults.length
                      : 1,
              itemBuilder: (context, index) {
                if (favoriteStoreSearchScreenviewModel.searchResults.isEmpty) {
                  return const ListTile(
                    title: Text(TranslationEN.storeNotFound),
                  );
                }

                final storeMap =
                    favoriteStoreSearchScreenviewModel.searchResults[index];
                final storeId = storeMap.id;
                final isFavorited = favoriteStoreSearchScreenviewModel
                    .favoriteStores
                    .contains(storeId);

                return ListTile(
                  title: Text(storeMap.name),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : null,
                    ),
                    onPressed: () => favoriteStoreSearchScreenviewModel
                        .toggleFavoriteStatus(storeId),
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
