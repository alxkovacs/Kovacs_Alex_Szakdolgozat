import 'package:application/model/price_and_store_model.dart';
import 'package:application/service/product_screen_service.dart';
import 'package:flutter/material.dart';

class ProductScreenViewModel extends ChangeNotifier {
  final ProductScreenService _service = ProductScreenService();
  List<PriceAndStoreModel> prices = [];
  bool isLoading = false;
  bool isFavorite = false;
  bool isDataLoaded = false;

  Future<void> fetchPrices(String productId) async {
    isLoading = true;
    isDataLoaded = false;
    notifyListeners();

    try {
      prices = await _service.getPriceAndStoreList(productId);
      isDataLoaded = true;
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
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

  Future<bool> addPrice(String productId, String storeName, int price) async {
    isLoading = true;
    notifyListeners();
    try {
      bool result =
          await _service.addPriceWithTimestamp(productId, storeName, price);
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
