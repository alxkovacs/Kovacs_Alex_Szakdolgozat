import 'package:application/model/product_dto.dart';
import 'package:application/model/product_model.dart';
import 'package:application/model/user_dto.dart';
import 'package:application/model/user_model.dart';
import 'package:application/service/home_screen_service.dart';
import 'package:flutter/material.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/favorites_screen.dart';
import 'package:application/view/screens/shopping_list_screen.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final HomeScreenService _homeScreenService = HomeScreenService();
  String userFirstName = TranslationEN.noData;
  List<ProductModel> topViewedProducts = [];
  // List<Map<String, dynamic>> menu = [
  //   {
  //     'name': TranslationEN.shoppingList,
  //     'goToPage': () => const ShoppingListScreen(),
  //   },
  //   {
  //     'name': TranslationEN.favorites,
  //     'goToPage': () => const FavoritesScreen(),
  //   },
  // ];

  HomeScreenViewModel() {
    notifyListeners();
  }

  Future<void> fetchTopViewedProducts() async {
    List<ProductDTO> productDTOs =
        await _homeScreenService.fetchTopViewedProducts();
    topViewedProducts =
        productDTOs.map((dto) => ProductModel.fromProductDTO(dto)).toList();
    notifyListeners();
  }

  Future<void> fetchUserData(String userId) async {
    UserDTO userDTO = await _homeScreenService.fetchUserName(userId);
    UserModel user = UserModel.fromUserDTO(userDTO);
    userFirstName = user.firstName!;
    notifyListeners();
  }

  void fetchData(String userId) {
    fetchUserData(userId);
    fetchTopViewedProducts();
  }

  Future<int> getProductsCount() async {
    return _homeScreenService.getDocumentCount('products');
  }

  Future<int> getStoresCount() async {
    return _homeScreenService.getDocumentCount('stores');
  }
}
