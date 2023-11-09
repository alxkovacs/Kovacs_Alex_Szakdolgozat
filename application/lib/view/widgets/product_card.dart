import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String productName;
  final String price;
  final String storeName;

  const ProductCard({
    Key? key,
    required this.productName,
    required this.price,
    required this.storeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.0,
      margin: EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(67, 153, 182, 1.00),
              width: 2.0, // Vastag kék szegély az alján
            ),
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 0.0), // Állítsd be a ListTile paddingját
          title: Text(
            productName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Text(
            storeName + ' - ' + 'Fürdőszoba',
          ),
          trailing: Text(
            price,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
