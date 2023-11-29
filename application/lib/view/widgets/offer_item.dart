import 'package:flutter/material.dart';

class OfferItem extends StatelessWidget {
  const OfferItem({
    Key? key,
    required this.number,
    required this.title,
    required this.store,
    required this.emoji,
  }) : super(key: key);

  final int number;
  final String title;
  final String store;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0, // A kívánt szélesség beállítása
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // A kerekítés mértékének beállítása
        ),
        elevation: 0.0,
        color: Color.fromRGBO(
            67, 153, 182, 0.5), // Itt állítod be a neonzöld háttérszínt
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              20.0), // A kép kerekítésének beállítása, hogy illeszkedjen a Card-ra
          child: Center(
            // Középre igazítja az emoji-t
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: 60, // Nagyobb betűméret beállítása az emoji számára
              ),
            ),
          ),
        ),
      ),
    );
  }
}
