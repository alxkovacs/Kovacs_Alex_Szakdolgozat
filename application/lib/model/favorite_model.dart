import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  final String id;
  final String name;
  final String category;
  final String emoji;

  FavoriteModel({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
  });

  factory FavoriteModel.fromDocument(DocumentSnapshot productSnapshot) {
    var data = productSnapshot.data() as Map<String, dynamic>;

    return FavoriteModel(
      id: productSnapshot.id,
      name: data['name'],
      category: data['category']['name'],
      emoji: data['category']['emoji'],
    );
  }
}
