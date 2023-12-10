import 'package:application/model/product_model.dart';
import 'package:application/service/shopping_list_screen_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShoppingListScreenViewModel extends ChangeNotifier {
  final ShoppingListScreenService _shoppingListService =
      ShoppingListScreenService();
  List<ProductModel> shoppingListItems = [];
  List<Map<String, dynamic>> favoriteStoresTotals = [];
  Map<String, dynamic> cheapestStoreTotal = {};

  ShoppingListScreenViewModel() {
    listenToUserChanges();
  }

  List<ProductModel> get getShoppingListItems => shoppingListItems;
  List<Map<String, dynamic>> get getFavoriteStoresTotals =>
      favoriteStoresTotals;
  Map<String, dynamic> get getCheapestStoreTotal => cheapestStoreTotal;

  void _initialize() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      updateShoppingListItems(userId);
      updateFavoriteStoresTotals(userId);
      updateCheapestStoreTotal(userId);
    } else {
      clearData();
    }
  }

  void listenToUserChanges() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _initialize();
      } else {
        clearData();
      }
    });
  }

  void clearData() {
    shoppingListItems = [];
    favoriteStoresTotals = [];
    cheapestStoreTotal = {};
    notifyListeners();
  }

  Future<void> updateShoppingListItems(String userId) async {
    var productDTOs =
        await _shoppingListService.getShoppingListStream(userId).first;
    shoppingListItems =
        productDTOs.map((dto) => ProductModel.fromProductDTO(dto)).toList();
    notifyListeners();
  }

  Future<void> updateFavoriteStoresTotals(String userId) async {
    favoriteStoresTotals =
        await _shoppingListService.getFavoriteStoresTotal(userId);
    notifyListeners();
  }

  Future<void> updateCheapestStoreTotal(String userId) async {
    cheapestStoreTotal =
        await _shoppingListService.getCheapestStoreTotal(userId);
    notifyListeners();
  }

  Future<void> removeProductFromShoppingList(
      String userId, String productId) async {
    await _shoppingListService.removeProductFromShoppingList(userId, productId);
    await updateShoppingListItems(userId);
    await updateFavoriteStoresTotals(userId);
    await updateCheapestStoreTotal(userId);
  }
}
