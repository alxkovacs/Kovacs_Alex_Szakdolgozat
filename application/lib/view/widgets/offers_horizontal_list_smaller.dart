import 'package:application/view/widgets/offer_item.dart';
import 'package:application/view/widgets/offer_item_smaller.dart';
import 'package:application/view/widgets/product_item.dart';
import 'package:flutter/material.dart';

class OffersHorizontalListSmaller extends StatelessWidget {
  OffersHorizontalListSmaller({super.key});

  final List<Map<String, dynamic>> products = [
    {
      'title': 'Dyson V15 Detect Absolute',
      'subtitle': 'Laidi',
      'image':
          'assets/images/offer_03_image.png' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image':
          'assets/images/offer_02_image.png' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image':
          'assets/images/offer_04_image.png' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image':
          'assets/images/offer_02_image.png' // Replace with your image asset path
    },
    {
      'title': 'VILEDA Ultramat Turbo felmosó szett',
      'subtitle': 'Lokta',
      'image':
          'assets/images/offer_03_image.png' // Replace with your image asset path
    },
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          // A padding most az elem bal oldalán lesz, kivéve az első elemet
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 10.0 : 0,
              right: 10.0, // Minden elem után 15.0 logikai pixel a távolság
            ),
            child: OfferItemSmaller(
              number: index,
              title: products[index]['title'],
              store: products[index]['subtitle'],
              imageName: products[index]['image'],
            ),
          );
        },
      ),
    );
  }
}
