import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Árak lekérdezésére szolgáló provider
final productPricesProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>(
        (ref, String productId) {
  return FirebaseFirestore.instance
      .collection('productPrice')
      .where('productID', isEqualTo: productId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList());
});
