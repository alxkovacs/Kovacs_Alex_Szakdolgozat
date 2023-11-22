import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String id;
  final String name;

  Store({required this.id, required this.name});

  factory Store.fromFirestore(DocumentSnapshot doc) {
    return Store(
      id: doc.id,
      name: doc['name'] as String,
    );
  }
}
