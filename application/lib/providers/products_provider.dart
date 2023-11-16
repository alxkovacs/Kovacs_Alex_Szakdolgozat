import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, List<Map<String, dynamic>>>((ref) {
  return ProductsNotifier();
});

class ProductsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  StreamSubscription? _productsSubscription;

  ProductsNotifier() : super([]) {
    listenToProducts();
  }

  void listenToProducts() {
    _productsSubscription =
        FirebaseFirestore.instance.collection('products').snapshots().listen(
      (querySnapshot) {
        state = querySnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'product': doc.data()['product'] as String,
                  'category': doc.data()['category']
                      as String, // Modify as per your data structure
                  'emoji': doc.data()['emoji'] as String,
                })
            .toList();
      },
      onError: (error) {
        // Log the error
        if (error is FirebaseException) {
          print('A Firebase hiba történt: ${error.message}');
        } else {
          print('Ismeretlen hiba történt: $error');
        }
        // Optionally, you could expose the error state to the UI
        state = [];
        // Here you could also set a flag to indicate that an error occurred
        // Or you can use a StateNotifier that holds a more complex state, with a loading/error/data status
      },
    );
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }
}
