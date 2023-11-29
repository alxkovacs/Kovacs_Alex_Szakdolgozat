import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String storeId;

  Offer({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.storeId,
  });

  // Egy factory konstruktor, ami létrehoz egy OfferItem példányt egy Firestore dokumentumból
  factory Offer.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Itt feltételezzük, hogy minden mező létezik a dokumentumban,
    // de érdemes lehet kezelni a hiányzó mezők vagy null értékek esetét is.
    return Offer(
      id: doc.id, // Firestore dokumentum azonosító
      name: data['name'] ??
          '', // Ha a 'name' mező null, üres string lesz helyette
      description: data['description'],
      emoji: data['emoji'] ?? '',
      storeId: data['storeId'] ?? '',
    );
  }

  // Egy metódus, ami egy Map-pé konvertálja az OfferItem példányt
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'emoji': emoji,
      'storeId': storeId,
    };
  }
}
