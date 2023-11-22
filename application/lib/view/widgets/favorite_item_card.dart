import 'package:application/model/favorite.dart';
import 'package:application/view/screens/product_screen.dart';
import 'package:flutter/material.dart';

class FavoriteItemCard extends StatelessWidget {
  const FavoriteItemCard({
    Key? key,
    required this.favorite,
  }) : super(key: key);

  final Favorite favorite;

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
          id: favorite.id,
          product: favorite.name,
          category: favorite.category,
          emoji: favorite.emoji,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToDetails(context),
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10, // Növeli az utolsó elem alatti térközt
          right: 10,
          left: 10,
          top: 10, // Növeli az első elem feletti térközt
        ), // Térköz a ListTile-ok között
        decoration: BoxDecoration(
          color: Colors.white, // Háttérszín beállítása
          borderRadius: BorderRadius.circular(30.0), // Keret lekerekítése
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(67, 153, 182, 0.5),
              // color: Colors.green.shade900,
              offset: const Offset(
                5.0,
                5.0,
              ),
              blurRadius: 15.0,
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
        child: Card(
          shadowColor: Colors.transparent,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              top: 0,
              right: 10,
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      favorite.emoji, // Porszívó emoji🫧📺🧹
                      style: TextStyle(
                        fontSize:
                            70.0, // állítsd be a méretet, hogy illeszkedjen a layout-hoz
                      ),
                    ),
                  ),
                ),
                Text(
                  favorite.name, // Termék neve
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${favorite.category}', // Termék ára
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
