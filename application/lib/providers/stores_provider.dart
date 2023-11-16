import 'package:application/model/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storesProvider = StreamProvider<List<Store>>((ref) {
  Stream<QuerySnapshot> snapshot =
      FirebaseFirestore.instance.collection('stores').snapshots();

  return snapshot.map((snapshot) {
    return snapshot.docs.map((doc) => Store.fromFirestore(doc)).toList();
  });
});
