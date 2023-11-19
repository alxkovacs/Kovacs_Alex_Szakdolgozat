import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListProduct {
  final String shoppingListId;
  final String productId;
  final String
      productName; // Opcionálisan, ha szeretnéd megjeleníteni a termék nevét is.
  // final int quantity; // Opcionálisan, ha szeretnéd tárolni a termékek mennyiségét is.
  // További mezők, mint például az ár, leírás stb., ha szükséges.

  ShoppingListProduct({
    required this.shoppingListId,
    required this.productId,
    this.productName = '', // Alapértelmezett érték, ha nincs megadva.
    // this.quantity = 1, // Alapértelmezett érték, ha nincs megadva.
  });

  // A Firestore dokumentumból történő példányosításhoz használható factory konstruktor.
  factory ShoppingListProduct.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ShoppingListProduct(
      shoppingListId: data['shoppingListId'],
      productId: data['productId'],
      productName: data['productName'] ??
          '', // Az elválasztójel jelzi, hogy az érték opcionális.
      // quantity: data['quantity'] ?? 1,
    );
  }

  // Egy metódus, ami segít a modell Firestore dokumentummá való konvertálásában.
  Map<String, dynamic> toFirestore() {
    return {
      'shoppingListId': shoppingListId,
      'productId': productId,
      'productName': productName,
      // 'quantity': quantity,
    };
  }
}
