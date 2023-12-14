import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteStoreDTO {
  final String id;
  final String name;
  final bool isFavorite;

  FavoriteStoreDTO(
      {required this.id, required this.name, required this.isFavorite});

  factory FavoriteStoreDTO.fromFirestore(
      DocumentSnapshot doc, bool isFavorite) {
    return FavoriteStoreDTO(
      id: doc.id,
      name: doc['name'] as String,
      isFavorite: isFavorite,
    );
  }

  Map<String, dynamic> toFirestoreJson() {
    return {
      'name': name,
    };
  }
}
