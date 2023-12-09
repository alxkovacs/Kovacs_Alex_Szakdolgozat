import 'package:application/service/products_screen_service.dart';
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
    fetchProducts();
  }

  void updateSearchTerm(String value) {
    searchTerm = value;
  }

  void fetchProducts() {
    _productService.fetchProductByName(_searchTerm).listen((productDTOList) {
      _products = productDTOList.map((dto) {
        return ProductModel(
          id: dto.id,
          product: dto.name,
          category: dto.category,
          emoji: dto.emoji,
        );
      }).toList();
      notifyListeners();
    });
  }
}
