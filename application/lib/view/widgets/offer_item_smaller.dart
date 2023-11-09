import 'package:flutter/material.dart';

class OfferItemSmaller extends StatelessWidget {
  const OfferItemSmaller({
    Key? key,
    required this.number,
    required this.title,
    required this.store,
    required this.imageName,
  }) : super(key: key);

  final int number;
  final String title;
  final String store;
  final String imageName;

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
        child: AspectRatio(
          aspectRatio: 1.0, // Négyzet alakú képet biztosít
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              imageName,
              fit: BoxFit.cover, // A kép kitölti a rendelkezésre álló teret
            ),
          ),
        ),
      ),
    );
  }
}
