import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/custom_search_bar.dart';
import 'package:application/view/widgets/product_card.dart';
import 'package:application/view_model/products_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productsScreenViewModel =
        Provider.of<ProductsScreenViewModel>(context);

    return Scaffold(
      backgroundColor: AppColor.lightBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          TranslationEN.products,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 15),
            child: CustomSearchBar(
              controller: _searchController,
              viewModel: productsScreenViewModel,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10, left: 25, right: 25),
              itemCount: productsScreenViewModel.products.length,
              itemBuilder: (context, index) {
                final productModel = productsScreenViewModel.products[index];
                return ProductCard(
                  productModel: productModel,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
