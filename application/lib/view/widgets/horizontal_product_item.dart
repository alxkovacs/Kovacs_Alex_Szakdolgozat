import 'package:application/view/screens/product_screen.dart';
import 'package:flutter/material.dart';

class HorizontalProductItem extends StatelessWidget {
  final int number;
  final String id;
  final String product;
  final String category;
  final String emoji;

  const HorizontalProductItem({
    Key? key,
    required this.number,
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
        // color: const Color.fromRGBO(67, 153, 182, 0.15),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 5.0), // Körbefuttatott padding
          child: Row(
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.all(7), // A padding beállítása az emoji körül.
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
              SizedBox(width: 15.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '${number + 1}',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis, // Több sor esetén pontokkal zárul
                ),
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product,
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow
                          .ellipsis, // Több sor esetén pontokkal zárul
                    ),
                    Text(
                      category,
                      style: TextStyle(fontSize: 12.0),
                      maxLines: 1,
                      overflow: TextOverflow
                          .ellipsis, // Több sor esetén pontokkal zárul
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios, // Nyíl ikon.
                size: 18.0, // A nyíl mérete.
                color: Colors.black, // A nyíl színe.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
