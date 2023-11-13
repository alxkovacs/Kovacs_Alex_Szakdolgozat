import 'package:application/view/widgets/product_item.dart';
import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  HorizontalList({super.key});

  final List<Map<String, dynamic>> products = [
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
        itemCount: offers.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              left:
                  index < 3 ? 10 : 0, // Az első elemnek adunk bal oldali margót
              right: index > 5 ? 10 : 0,
            ),
            child: ProductItem(
              number: index,
              title: offers[index]['title'],
              store: offers[index]['subtitle'],
              imageName: offers[index]['image'],
            ),
          );
        },
      ),
    );
  }
}
