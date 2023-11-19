import 'package:application/view/widgets/horizontal_product_item.dart';
import 'package:application/view/widgets/product_card.dart';
import 'package:application/view/widgets/product_item.dart';
import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  HorizontalList({super.key, required this.products});

  final List<Map<String, dynamic>> offers = [
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Laidi',
      'image': '🪠' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image': '🪠' // Replace with your image asset path
    },
    {
      'title': 'Dyson V15 Detect Absolute',
      'subtitle': 'Laidi',
      'image': '🪠' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image': '🪠' // Replace with your image asset path
    },
    {
      'title': 'Dyson V15 Detect Absolute',
      'subtitle': 'Laidi',
      'image': '🪠' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image': '🪠' // Replace with your image asset path
    },
    {
      'title': 'Dyson V15 Detect Absolute',
      'subtitle': 'Laidi',
      'image': '🪠' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image': '🪠' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image': '🪠' // Replace with your image asset path
    },
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 220, // A magasság megadása elegendő lehet a GridView számára
      child: GridView.builder(
        shrinkWrap: true, // A GridView méretének korlátozása a tartalomhoz
        physics: ScrollPhysics(), // Engedélyezi a vízszintes görgetést
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 0, // Függőleges térköz
          mainAxisSpacing: 10, // Vízszintes térköz
          childAspectRatio: 0.195, // Az elemek arányának beállítása
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              left:
                  index < 3 ? 0 : 0, // Az első elemnek adunk bal oldali margót
              right: index > 5 ? 10 : 0,
            ),
            child: HorizontalProductItem(
              number: index,
              id: products[index]['id'],
              product: products[index]['name'],
              category: products[index]['category']['name'],
              emoji: products[index]['category']['emoji'],
            ),
            // ProductItem(
            //   number: index,
            //   title: products[index]['name'],
            //   categoryName: products[index]['category']['name'],
            //   imageName: products[index]['category']['emoji'],
            // ),
            // child: ProductCard(
            //   id: products[index]['id'],
            //   product: products[index]['name'],
            //   category: products[index]['category']['name'],
            //   emoji: products[index]['category']['emoji'],
            //   // feltételezve, hogy a ProductCard widget támogatja az árat is
            //   // price: product['price'].toString(),
            // ),
          );
        },
      ),
    );
  }
}
