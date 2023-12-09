import 'package:cloud_firestore/cloud_firestore.dart';

class OfferDTO {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String storeId;

  OfferDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.storeId,
  });

  factory OfferDTO.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return OfferDTO(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      emoji: data['emoji'] ?? '',
      storeId: data['storeId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestoreJson() {
    return {
      'name': name,
      'description': description,
      'emoji': emoji,
      'storeId': storeId,
    };
  }
}
