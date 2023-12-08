import 'package:application/model/store_model.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/store_search_field.dart';
import 'package:application/view_model/store_search_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreSearchScreen extends StatefulWidget {
  const StoreSearchScreen({super.key});

  @override
  _StoreSearchScreenState createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends State<StoreSearchScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<StoreSearchScreenViewModel>(context, listen: false)
        .loadInitialStores();
  }

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
          StoreSearchField(
              storeSearchScreenViewModel: storeSearchScreenViewModel),
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
