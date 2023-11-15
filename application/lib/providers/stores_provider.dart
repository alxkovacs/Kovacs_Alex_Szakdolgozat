import 'package:application/model/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storesProvider = FutureProvider<List<Store>>((ref) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('stores').get();
  return snapshot.docs.map((doc) => Store.fromFirestore(doc)).toList();
});
