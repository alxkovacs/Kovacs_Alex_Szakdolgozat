import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String categoryName;
  final String categoryEmoji;

  Product(
      {required this.id,
      required this.name,
      required this.categoryName,
      required this.categoryEmoji});

  factory Product.fromDocument(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'],
      categoryName: data['category']['name'],
      categoryEmoji: data['category']['emoji'],
    );
  }
}
