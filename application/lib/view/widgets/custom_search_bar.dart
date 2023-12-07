import 'package:flutter/material.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view_model/products_screen_view_model.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ProductsScreenViewModel viewModel;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: AppColor.mainColor,
      controller: controller,
      onChanged: (value) {
        viewModel.searchTerm = value;
      },
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.all(0),
        hintText: '${TranslationEN.searchBetweenProducts}...',
        hintStyle: TextStyle(
          color: AppColor.mainColor.withOpacity(0.75),
        ),
        filled: true,
        fillColor: AppColor.mainColor.withOpacity(0.20),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.clear,
            color: AppColor.mainColor,
          ),
          onPressed: () {
            controller.clear();
            viewModel.searchTerm = '';
          },
        ),
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
    );
  }
}
