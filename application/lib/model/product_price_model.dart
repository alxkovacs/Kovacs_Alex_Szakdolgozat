import 'package:cloud_firestore/cloud_firestore.dart';

class ProductPriceModel {
  final String productId;
  final int price;
  final DateTime timestamp;

  ProductPriceModel(
      {required this.productId, required this.price, required this.timestamp});

  // Firestore dokumentumból történő létrehozás
  factory ProductPriceModel.fromFirestore(Map<String, dynamic> firestoreData) {
    return ProductPriceModel(
      productId: firestoreData['productId'],
      price: firestoreData['price'],
      timestamp: (firestoreData['timestamp'] as Timestamp).toDate(),
    );
  }
}
