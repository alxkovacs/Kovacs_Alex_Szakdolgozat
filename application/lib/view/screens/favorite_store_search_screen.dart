import 'package:application/providers/favorite_stores_provider.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteStoreSearchScreen extends ConsumerStatefulWidget {
  const FavoriteStoreSearchScreen({super.key});

  @override
  _FavoriteStoreSearchScreenState createState() =>
      _FavoriteStoreSearchScreenState();
}

class _FavoriteStoreSearchScreenState
    extends ConsumerState<FavoriteStoreSearchScreen> {
  @override
  void initState() {
    super.initState();
    // Kezdeti adatok betöltése
    ref.read(favoriteStoresProvider.notifier).loadInitialStoresAsync();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(favoriteStoresProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(TranslationEN.chooseLocation),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              onChanged: (value) =>
                  viewModel.performSearch(value.toLowerCase()),
              decoration: Styles.storeSearchDecoration,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.searchResults.isNotEmpty
                  ? viewModel.searchResults.length
                  : 1,
              itemBuilder: (context, index) {
                if (viewModel.searchResults.isEmpty) {
                  return const ListTile(
                    title: Text(TranslationEN.storeNotFound),
                  );
                }

                final storeMap = viewModel.searchResults[index];
                final storeId = storeMap['id']!;
                final isFavorited = viewModel.favoriteStores
                    .contains(storeId); // Mindig frissítsd ezt

                return ListTile(
                  title: Text(storeMap['name']!),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : null,
                    ),
                    onPressed: () => viewModel.toggleFavoriteStatus(storeId),
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
