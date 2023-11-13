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
            // color: Color.fromRGBO(67, 153, 182, 0.15),
            // borderRadius: BorderRadius.circular(15.0),
            // border:
            //     Border.all(color: Color.fromRGBO(67, 153, 182, 0.5), width: 2),
            // border: Border(
            //   bottom: BorderSide(
            //     color: Color.fromRGBO(67, 153, 182, 1.00),
            //     width: 1.0, // Vastag kék szegély az alján
            //   ),
            // ),
            ),
        child: ListTile(
          // leading: Text(
          //   storeName,
          //   style: TextStyle(fontSize: 30),
          // ),
          leading: Container(
            padding: EdgeInsets.all(11), // A padding beállítása az emoji körül.
            decoration: BoxDecoration(
              color: Colors.white, // Zöld háttér beállítása.
              shape: BoxShape.circle, // Kerek forma a konténernek.
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(67, 153, 182, 0.5),
                  // color: Colors.green.shade900,

                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                ), //BoxShadow
                BoxShadow(
                  color: Colors.white,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
              ],
            ),
            child: Text(
              storeName, // Itt helyezze el az emojit.
              style: TextStyle(fontSize: 24), // Emoji méretének beállítása.
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 0.0), // Állítsd be a ListTile paddingját
          title: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Több sor esetén pontokkal zárul
            productName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Text(
            price,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        ),
      ),
    );
  }
}
