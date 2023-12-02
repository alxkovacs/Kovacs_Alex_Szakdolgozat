import 'package:application/model/favorite_model.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/view/screens/product_screen.dart';
import 'package:flutter/material.dart';

class FavoriteItemCard extends StatelessWidget {
  const FavoriteItemCard({
    Key? key,
    required this.favorite,
  }) : super(key: key);

  final FavoriteModel favorite;

  void navigateToDetails(BuildContext context) {
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
        margin: const EdgeInsets.only(
          bottom: 10, // Növeli az utolsó elem alatti térközt
          right: 10,
          left: 10,
          top: 10, // Növeli az első elem feletti térközt
        ), // Térköz a ListTile-ok között
        decoration: Styles.favoriteProductBoxDecoration,
        child: Card(
          shadowColor: Colors.transparent,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 0.0,
          child: Padding(
            padding: const EdgeInsets.only(
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
                      favorite.emoji,
                      style: const TextStyle(
                        fontSize:
                            70.0, // állítsd be a méretet, hogy illeszkedjen a layout-hoz
                      ),
                    ),
                  ),
                ),
                Text(
                  favorite.name, // Termék neve
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  favorite.category, // Termék ára
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
