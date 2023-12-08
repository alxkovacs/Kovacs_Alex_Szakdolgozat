import 'package:cloud_firestore/cloud_firestore.dart';

class StoreDTO {
  final String id;
  final String name;

  StoreDTO({required this.id, required this.name});

  factory StoreDTO.fromFirestore(DocumentSnapshot doc) {
    return StoreDTO(
      id: doc.id,
      name: doc['name'] as String,
    );
  }

  Map<String, dynamic> toFirestoreJson() {
    return {
      'name': name,
    };
  }
}
