import 'package:flutter/material.dart';
import 'package:application/model/product_price_model.dart';
import 'package:application/service/product_prices_screen_service.dart';

class ProductPricesScreenViewModel extends ChangeNotifier {
  final ProductPricesScreenService _service = ProductPricesScreenService();
  List<ProductPriceModel> prices = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  void fetchPrices(String productId, String storeId) {
    isLoading = true;
    hasError = false;
    errorMessage = '';
    notifyListeners();

    _service.fetchPrices(productId, storeId).listen(
      (dtoList) {
        prices = dtoList.map((dto) => ProductPriceModel.fromDTO(dto)).toList();
        isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        hasError = true;
        errorMessage = error.toString();
        isLoading = false;
        notifyListeners();
      },
    );
  }
}
