import 'package:application/providers/products_view_model_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/product_card.dart';
import 'package:application/view_model/products_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  Widget _buildSearchBar(ProductsScreenViewModel viewModel, WidgetRef ref) {
    return TextField(
      cursorColor: AppColor.mainColor,
      controller: _searchController,
      onChanged: (value) {
        viewModel.searchTerm = value;
      },
      decoration: InputDecoration(
        isDense: true, // Added this
        contentPadding: const EdgeInsets.all(0),
        hintText: '${TranslationEN.searchBetweenProducts}...',
        hintStyle: TextStyle(
          color: AppColor.mainColor.withOpacity(0.75),
        ),
        filled: true, // Ez engedélyezi a háttérszín beállítását
        fillColor: AppColor.mainColor
            .withOpacity(0.20), // A háttérszín beállítása kék színre
        // Adj hozzá egy tiszta gombot a keresősávhoz
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.clear,
            color: AppColor.mainColor,
          ),
          onPressed: () {
            _searchController.clear();
            viewModel.searchTerm = ''; // Frissíti a ViewModel keresési szövegét
          },
        ),
        // Adj hozzá egy kereső ikont vagy gombot a keresősávhoz
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

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(
        productsViewModelProvider); // Feltételezve, hogy van egy ilyen providered

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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: _buildSearchBar(viewModel, ref),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10, left: 25, right: 25),
              itemCount: viewModel.products.length,
              itemBuilder: (context, index) {
                final product = viewModel.products[index];
                return ProductCard(
                  id: product.id,
                  product: product.product,
                  category: product.category,
                  emoji: product.emoji,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
