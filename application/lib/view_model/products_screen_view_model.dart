import 'package:application/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsScreenViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<ProductModel> _products = [];
  String _searchTerm = '';

  ProductsScreenViewModel() {
    fetchProducts(); // A ViewModel inicializálásakor hívja meg
  }

  List<ProductModel> get products => _products;
  String get searchTerm => _searchTerm;

  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
    fetchProducts();
  }

  void fetchProducts() async {
    Stream<QuerySnapshot<Map<String, dynamic>>> stream;
    final lowercaseSearchTerm = searchTerm.toLowerCase();

    // Ha nincs keresési szöveg, minden terméket lekér
    if (lowercaseSearchTerm.isNotEmpty) {
      stream = _db
          .collection('products')
          .where('name_lowercase', isGreaterThanOrEqualTo: lowercaseSearchTerm)
          .where('name_lowercase',
              isLessThanOrEqualTo: '${lowercaseSearchTerm}\uf8ff')
          .snapshots();
    } else {
      stream = _db.collection('products').snapshots();
    }

    stream.listen((snapshot) {
      _products = snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel(
          id: doc.id,
          product: data['name'] as String? ?? '',
          category: data['category']['name'] as String? ?? '',
          emoji: data['category']['emoji'] as String? ?? '',
        );
      }).toList();
      notifyListeners();
    });
  }
}
