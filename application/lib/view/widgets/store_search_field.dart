import 'package:flutter/material.dart';
import 'package:application/utils/colors.dart';
import 'package:application/view_model/store_search_screen_view_model.dart';
import 'package:application/utils/translation_en.dart';

class StoreSearchField extends StatelessWidget {
  final StoreSearchScreenViewModel storeSearchScreenViewModel;

  const StoreSearchField({Key? key, required this.storeSearchScreenViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        cursorColor: AppColor.mainColor,
        onChanged: (value) =>
            storeSearchScreenViewModel.performSearch(value.toLowerCase()),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.all(0),
          hintText: '${TranslationEN.searchBetweenStores}...',
          hintStyle: TextStyle(
            color: AppColor.mainColor.withOpacity(0.75),
          ),
          filled: true,
          fillColor: AppColor.mainColor.withOpacity(0.2),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColor.mainColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: AppColor.mainColor.withOpacity(0.15),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: AppColor.mainColor.withOpacity(0.15),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: AppColor.mainColor.withOpacity(0.15),
            ),
          ),
        ),
      ),
    );
  }
}
