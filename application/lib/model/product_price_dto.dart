import 'package:cloud_firestore/cloud_firestore.dart';

class ProductPriceDTO {
  final String productId;
  final int price;
  final Timestamp timestamp;

  ProductPriceDTO({
    required this.productId,
    required this.price,
    required this.timestamp,
  });

  factory ProductPriceDTO.fromFirestore(Map<String, dynamic> firestoreData) {
    return ProductPriceDTO(
      productId: firestoreData['productId'],
      price: firestoreData['price'],
      timestamp: firestoreData['timestamp'],
    );
  }
}
