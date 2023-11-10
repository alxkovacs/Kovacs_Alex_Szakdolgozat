import 'package:application/view/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'store': 'Media Markt',
    },
    {
      'name': 'VILEDA Ultramat Turbo felmosó szett',
      'price': '13 890 Ft',
      'store': 'Lidl',
    },
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'store': 'Media Markt',
    },
    {
      'name': 'VILEDA Ultramat Turbo felmosó szett',
      'price': '13 890 Ft',
      'store': 'Lidl',
    },
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'store': 'Media Markt',
    },
    {
      'name': 'VILEDA Ultramat Turbo felmosó szett',
      'price': '13 890 Ft',
      'store': 'Lidl',
    },
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'store': 'Media Markt',
    },
    {
      'name': 'VILEDA Ultramat Turbo felmosó szett',
      'price': '13 890 Ft',
      'store': 'Lidl',
    },
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'store': 'Media Markt',
    },
    {
      'name': 'VILEDA Ultramat Turbo felmosó szett',
      'price': '13 890 Ft',
      'store': 'Lidl',
    },
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'store': 'Media Markt',
    },
    {
      'name': 'VILEDA Ultramat Turbo felmosó szett',
      'price': '13 890 Ft',
      'store': 'Lidl',
    },
    // További termékek...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'Termékek',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Container(
              // Add padding around the search bar
              padding: const EdgeInsets.all(0.0),
              // Use a Material design search bar
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(8),
                  hintText: 'Keresés a termékek között...',
                  filled: true, // Ez engedélyezi a háttérszín beállítását
                  fillColor: const Color.fromRGBO(
                      67, 153, 182, 0.20), // A háttérszín beállítása kék színre
                  // Adj hozzá egy tiszta gombot a keresősávhoz
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Color.fromRGBO(67, 153, 182, 1.0),
                    ),
                    onPressed: () => _searchController.clear(),
                  ),
                  // Adj hozzá egy kereső ikont vagy gombot a keresősávhoz
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Color.fromRGBO(67, 153, 182, 1.0),
                    ),
                    onPressed: () {
                      // Itt hajts végre keresést
                    },
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
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 10),
                itemCount: products.length, // itt a products a termékek listája
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    productName: product['name'],
                    price: product['price'],
                    storeName: product['store'],
                  );
                },
              ),
            ),
            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
