import 'package:application/model/store_model.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view_model/store_search_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreSearchScreen extends StatefulWidget {
  const StoreSearchScreen({super.key});

  @override
  _StoreSearchScreenState createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends State<StoreSearchScreen> {
  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final storeSearchScreenViewModel =
        Provider.of<StoreSearchScreenViewModel>(context);

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
                  storeSearchScreenViewModel.performSearch(value.toLowerCase()),
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
              itemCount: storeSearchScreenViewModel.searchResults.isNotEmpty
                  ? storeSearchScreenViewModel.searchResults.length
                  : 1,
              itemBuilder: (context, index) {
                if (storeSearchScreenViewModel.searchResults.isEmpty) {
                  return ListTile(
                    title: Text(
                        capitalize(storeSearchScreenViewModel.lastSearchTerm)),
                    onTap: () {
                      Navigator.pop(
                          context,
                          capitalize(
                              storeSearchScreenViewModel.lastSearchTerm));
                      FocusScope.of(context).unfocus();
                    },
                  );
                }
                StoreModel store =
                    storeSearchScreenViewModel.searchResults[index];
                return ListTile(
                  title: Text(store.name),
                  onTap: () {
                    Navigator.pop(context, store.name);
                    FocusScope.of(context).unfocus();
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
