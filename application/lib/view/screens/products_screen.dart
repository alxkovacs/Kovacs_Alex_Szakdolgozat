import 'package:application/providers/products_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/view/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchTerm = ref.watch(searchTermProvider);
    final productsStream = ref.watch(productsProvider(searchTerm));

    return Scaffold(
      // backgroundColor: Color.fromRGBO(67, 153, 182, 0.15),
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'Termékek',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Container(
              // Add padding around the search bar
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              // Use a Material design search bar
              child: TextField(
                onChanged: (value) {
                  // Frissítsd a keresőszó állapotát minden egyes karakter beírása után.
                  ref.read(searchTermProvider.notifier).state = value;
                },
                controller: _searchController,
                decoration: InputDecoration(
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(0),
                  hintText: 'Keresés a termékek között...',
                  hintStyle:
                      TextStyle(color: Color.fromRGBO(67, 153, 182, 0.75)),
                  filled: true, // Ez engedélyezi a háttérszín beállítását
                  fillColor: const Color.fromRGBO(
                      67, 153, 182, 0.20), // A háttérszín beállítása kék színre
                  // Adj hozzá egy tiszta gombot a keresősávhoz
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Color.fromRGBO(67, 153, 182, 1.0),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchTermProvider.notifier).state = '';
                    },
                  ),
                  // Adj hozzá egy kereső ikont vagy gombot a keresősávhoz
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color.fromRGBO(67, 153, 182, 1.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: const Color.fromRGBO(67, 153, 182, 0.15),
                    ), // A szegély színe piros
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: const Color.fromRGBO(67, 153, 182, 0.15),
                    ), // A szegély színe piros
                  ),
                  // Beállítja a fókuszált szegély színét is pirosra
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: const Color.fromRGBO(67, 153, 182, 0.15),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: productsStream.when(
                data: (products) => ListView.builder(
                  padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      id: product['id'],
                      product: product['product'],
                      category: product['category'],
                      emoji: product['emoji'],
                      // feltételezve, hogy a ProductCard widget támogatja az árat is
                      // price: product['price'].toString(),
                    );
                  },
                ),
                loading: () => Center(
                  child: const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColor.mainColor),
                  ),
                ),
                error: (error, stack) => Text('Hiba történt: $error'),
              ),
            ),
            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
