import 'package:flutter/material.dart';

class OfferItemSmaller extends StatelessWidget {
  const OfferItemSmaller({
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
      width: 150.0, // A kívánt szélesség beállítása
      height: 150.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // A kerekítés mértékének beállítása
        ),
        elevation: 0.0,
        color: Color.fromRGBO(
            67, 153, 182, 0.25), // Itt állítod be a neonzöld háttérszínt
        child: AspectRatio(
          aspectRatio: 1.0, // Négyzet alakú képet biztosít
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: 30, // Nagyobb betűméret beállítása az emoji számára
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
