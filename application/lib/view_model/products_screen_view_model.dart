import 'package:application/service/products_screen_service.dart';
import 'package:application/view/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:application/model/product_model.dart';

class ProductsScreenViewModel extends ChangeNotifier {
  final ProductsScreenService _productService = ProductsScreenService();
  List<ProductModel> _products = [];
  String _searchTerm = '';

  ProductsScreenViewModel() {
    fetchProducts();
  }

  List<ProductModel> get products => _products;
  String get searchTerm => _searchTerm;

  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
    fetchProducts();
  }

  void fetchProducts() {
    _productService.fetchProducts(_searchTerm).listen((productList) {
      _products = productList;
      notifyListeners();
    });
  }

  void navigateToDetails(BuildContext context, ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          id: product.id,
          product: product.product,
          category: product.category,
          emoji: product.emoji,
        ),
      ),
    );
  }
}
