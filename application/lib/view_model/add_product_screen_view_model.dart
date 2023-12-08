import 'package:application/model/category_model.dart';
import 'package:application/model/product_dto.dart';
import 'package:application/model/product_model.dart';
import 'package:application/service/add_product_screen_service.dart';
import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';

class AddProductScreenViewModel extends ChangeNotifier {
  final AddProductService _addProductService = AddProductService();
  final ProductModel _productModel =
      ProductModel(id: '', product: '', category: '', emoji: '');

  bool _isLoading = false;
  String _storeName = TranslationEN.chooseLocation;
  int _price = 0;
  CategoryModel? _selectedCategory =
      categories.isNotEmpty ? categories.first : null;

  AddProductScreenViewModel() {
    if (_selectedCategory != null) {
      _productModel.category = _selectedCategory!.name;
      _productModel.emoji = _selectedCategory!.emoji;
    }
  }

  bool get isLoading => _isLoading;
  String get storeName => _storeName;
  CategoryModel? get selectedCategory => _selectedCategory;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set enteredProductName(String value) {
    _productModel.product = value;
    notifyListeners();
  }

  set enteredCategoryName(String value) {
    _productModel.category = value;
    notifyListeners();
  }

  set enteredCategoryEmoji(String value) {
    _productModel.emoji = value;
    notifyListeners();
  }

  set enteredStoreName(String value) {
    _storeName = value;
    notifyListeners();
  }

  set enteredPrice(int value) {
    _price = value;
    notifyListeners();
  }

  set selectedCategory(CategoryModel? category) {
    _selectedCategory = category;
    if (category != null) {
      enteredCategoryName = category.name;
      enteredCategoryEmoji = category.emoji;
    }
    notifyListeners();
  }

  String? validateProductName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return TranslationEN.productValidator;
    }
    return null;
  }

  String? validateStoreName() {
    if (_storeName == TranslationEN.chooseLocation || _storeName.isEmpty) {
      return TranslationEN.chooseLocationFirst;
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return TranslationEN.priceValidator;
    }
    if (int.tryParse(value.trim()) == null) {
      return TranslationEN.priceIntValidator;
    }
    return null;
  }

  Future<bool> submitProduct(BuildContext context) async {
    isLoading = true;

    try {
      ProductDTO productDTO = _productModel.toProductDTO();

      bool result = await _addProductService.addOrUpdateProduct(
          productDTO, _storeName, _price);

      isLoading = false;
      return result;
    } catch (e) {
      if (context.findRenderObject() != null) {
        _showSnackbar(context, TranslationEN.addProductError);
      }
      isLoading = false;
      return false;
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    if (context.findRenderObject() != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
