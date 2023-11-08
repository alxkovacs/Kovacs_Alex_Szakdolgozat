import 'package:application/view/widgets/product_item.dart';
import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  HorizontalList({super.key});

  final List<Map<String, dynamic>> products = [
    {
      'title': 'Dyson V15 Detect Absolute',
      'subtitle': 'Laidi',
      'image':
          'assets/images/dyson_v15.png' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image':
          'assets/images/dyson_v15.png' // Replace with your image asset path
    },
    {
      'title': 'Dyson V15 Detect Absolute',
      'subtitle': 'Laidi',
      'image':
          'assets/images/dyson_v15.png' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image':
          'assets/images/dyson_v15.png' // Replace with your image asset path
    },
    {
      'title': 'Dyson V15 Detect Absolute',
      'subtitle': 'Laidi',
      'image':
          'assets/images/dyson_v15.png' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image':
          'assets/images/dyson_v15.png' // Replace with your image asset path
    },
    {
      'title': 'Dyson V15 Detect Absolute',
      'subtitle': 'Laidi',
      'image':
          'assets/images/dyson_v15.png' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image':
          'assets/images/dyson_v15.png' // Replace with your image asset path
    },
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height:
          240, // Dupla magasságra lesz szükség, hogy két elemet is meg tudj jeleníteni egymás alatt
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Két elemet helyez el függőlegesen
          crossAxisSpacing: 5, // Függőleges térköz
          mainAxisSpacing: 10, // Vízszintes térköz
          childAspectRatio:
              0.202, // Az elemek arányának beállítása, szükség szerint módosítható
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductItem(
            number: index,
            title: products[index]['title'],
            store: products[index]['subtitle'],
            imageName: products[index]['image'],
          );
        },
      ),
    );
  }
}
