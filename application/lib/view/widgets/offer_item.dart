import 'package:flutter/material.dart';

class OfferItem extends StatelessWidget {
  const OfferItem({
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
      width: 300.0, // A kívánt szélesség beállítása
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // A kerekítés mértékének beállítása
        ),
        elevation: 0.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              20.0), // A kép kerekítésének beállítása, hogy illeszkedjen a Card-ra
          child: Image.asset(
            imageName,
            fit: BoxFit.cover, // A kép kitölti a rendelkezésre álló helyet
          ),
        ),
      ),
    );
  }
}
