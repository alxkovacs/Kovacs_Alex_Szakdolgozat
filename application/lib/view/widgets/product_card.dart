import 'package:application/view/screens/product_screen.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String product;
  final String category;
  final String emoji;

  const ProductCard({
    Key? key,
    required this.id,
    required this.product,
    required this.category,
    required this.emoji,
  }) : super(key: key);

  void navigateToDetails(BuildContext context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         ProductScreen(), // DetailsPage(productName: productName), // Ide jön az új oldalad
    //   ),
    // );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          id: id,
          product: product,
          category: category,
          emoji: emoji,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToDetails(context),
      child: Card(
        color: Colors.white,
        elevation: 0.0,
        margin: EdgeInsets.only(bottom: 10),
        child: Container(
          child: ListTile(
            // leading: Text(
            //   storeName,
            //   style: TextStyle(fontSize: 30),
            // ),
            leading: Container(
              padding:
                  EdgeInsets.all(11), // A padding beállítása az emoji körül.
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
                emoji, // Itt helyezze el az emojit.
                style: TextStyle(fontSize: 24), // Emoji méretének beállítása.
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 0.0), // Állítsd be a ListTile paddingját
            title: Text(
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis, // Több sor esetén pontokkal zárul
              product,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            subtitle: Text(
              category,
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
      ),
    );
  }
}
