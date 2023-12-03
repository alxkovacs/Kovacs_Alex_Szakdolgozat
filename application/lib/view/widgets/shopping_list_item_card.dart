import 'package:application/utils/colors.dart';
import 'package:flutter/material.dart';

class ShoppingListItemCard extends StatelessWidget {
  final String id;
  final String name;
  final String categoryName;
  final String emoji;
  final VoidCallback onRemove; // Hozzáadunk egy új paramétert

  const ShoppingListItemCard({
    Key? key,
    required this.id,
    required this.name,
    required this.categoryName,
    required this.emoji,
    required this.onRemove, // Kötelező paraméterként kezeljük
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding:
              const EdgeInsets.all(11), // A padding beállítása az emoji körül.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white, // Zöld háttér beállítása.
            shape: BoxShape.rectangle, // Kerek forma a konténernek.
            boxShadow: [
              BoxShadow(
                color: AppColor.mainColor.withOpacity(0.5),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ), //BoxShadow
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ), //BoxShadow
            ],
          ),
          child: Text(
            emoji, // Itt helyezze el az emojit.
            style: const TextStyle(fontSize: 24), // Emoji méretének beállítása.
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 25.0), // Állítsd be a ListTile paddingját
        title: Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // Több sor esetén pontokkal zárul
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          categoryName,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
          onPressed: onRemove, // Itt adjuk hozzá az eseménykezelőt
        ),
      ),
    );
  }
}
