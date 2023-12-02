import 'package:application/providers/store_search_view_model_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreSearchScreen extends ConsumerStatefulWidget {
  const StoreSearchScreen({super.key});

  @override
  _StoreSearchScreenState createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends ConsumerState<StoreSearchScreen> {
  List<String> searchResults = [];

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  void initState() {
    super.initState();
    ref.read(storeSearchViewModelProvider).resetAndLoadInitialStores();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeSearchViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(TranslationEN.chooseLocation),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              cursorColor: AppColor.mainColor,
              onChanged: (value) =>
                  viewModel.performSearch(value.toLowerCase()),
              decoration: InputDecoration(
                isDense: true, // Added this
                contentPadding: const EdgeInsets.all(0),
                hintText: '${TranslationEN.searchBetweenStores}...',
                hintStyle: TextStyle(
                  color: AppColor.mainColor.withOpacity(0.75),
                ),
                filled: true, // Ez engedélyezi a háttérszín beállítását
                fillColor: AppColor.mainColor
                    .withOpacity(0.2), // A háttérszín beállítása kék színre
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColor.mainColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: AppColor.mainColor.withOpacity(0.15),
                  ), // A szegély színe piros
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: AppColor.mainColor.withOpacity(0.15),
                  ), // A szegély színe piros
                ),
                // Beállítja a fókuszált szegély színét is pirosra
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: AppColor.mainColor.withOpacity(0.15),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.searchResults.isNotEmpty
                  ? viewModel.searchResults.length
                  : 1,
              itemBuilder: (context, index) {
                if (viewModel.searchResults.isEmpty) {
                  return ListTile(
                    title: Text(capitalize(viewModel.lastSearchTerm)),
                    onTap: () {
                      Navigator.pop(
                          context, capitalize(viewModel.lastSearchTerm));
                      FocusScope.of(context)
                          .unfocus(); // Ez zárja be a billentyűzetet
                    },
                  );
                }
                return ListTile(
                  title: Text(viewModel.searchResults[index]),
                  onTap: () {
                    Navigator.pop(context, viewModel.searchResults[index]);
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
