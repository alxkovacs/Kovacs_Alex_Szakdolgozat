import 'package:application/model/price_and_store_dto.dart';
import 'package:application/model/price_and_store_model.dart';
import 'package:application/service/product_screen_service.dart';
import 'package:flutter/material.dart';

class ProductScreenViewModel extends ChangeNotifier {
  final ProductScreenService _service = ProductScreenService();
  List<PriceAndStoreModel> prices = [];
  bool isLoading = false;
  bool isFavorite = false;
  bool isDataLoaded = false;

  int _enteredPrice = 0;
  String _selectedLocation = '';

  int get enteredPrice => _enteredPrice;
  String get selectedLocation => _selectedLocation;

  set enteredPrice(int newValue) {
    _enteredPrice = newValue;
    notifyListeners();
  }

  set selectedLocation(String newValue) {
    _selectedLocation = newValue;
    notifyListeners();
  }

  Future<void> fetchPrices(String productId) async {
    isLoading = true;
    isDataLoaded = false;
    notifyListeners();

    try {
      List<PriceAndStoreDTO> dtoList =
          await _service.getPriceAndStoreListDTO(productId);
      prices = dtoList
          .map((dto) => PriceAndStoreModel(
                storeId: dto.storeId,
                storeName: dto.storeName,
                price: _calculateMedian(dto.prices),
                priceCount: dto.prices.length,
              ))
          .toList();

      prices.sort((a, b) => a.price.compareTo(b.price));

      isDataLoaded = true;
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  int _calculateMedian(List<int> prices) {
    prices.sort();
    int middle = prices.length ~/ 2;
    if (prices.length % 2 == 1) {
      return prices[middle];
    } else {
      return ((prices[middle - 1] + prices[middle]) / 2).round();
    }
  }

  Future<void> addProductToShoppingList(String productId, String userId) async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.addProductToShoppingList(productId, userId);
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkFavoriteStatus(String productId, String userId) async {
    isLoading = true;
    notifyListeners();
    isFavorite = await _service.isProductFavorited(productId, userId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId, String userId) async {
    isLoading = true;
    notifyListeners();
    if (isFavorite) {
      await _service.removeProductFromFavorites(productId, userId);
    } else {
      await _service.addProductToFavorites(productId, userId);
    }
    isFavorite = !isFavorite;
    isLoading = false;
    notifyListeners();
  }

  Future<void> incrementViewCount(String productId) async {
    await _service.incrementProductViewCount(productId);
  }

  Future<bool> addPrice(String productId) async {
    isLoading = true;
    notifyListeners();
    try {
      bool result = await _service.addPriceWithTimestamp(
          productId, selectedLocation, enteredPrice);
      if (result) {
        await fetchPrices(productId);
      }
      return result;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
