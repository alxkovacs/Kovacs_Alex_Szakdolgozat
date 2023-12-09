import 'package:application/model/product_dto.dart';
import 'package:application/model/product_model.dart';
import 'package:application/service/offer_screen_service.dart';
import 'package:flutter/material.dart';

class OfferScreenViewModel extends ChangeNotifier {
  final OfferService _offerService = OfferService();
  String storeName = '';
  List<ProductModel> products = [];

  void fetchData(String offerId, String storeId) {
    fetchStoreName(storeId);
    fetchOfferProducts(offerId);
    incrementOfferViewCount(offerId);
  }

  Future<void> fetchStoreName(String storeId) async {
    storeName = await _offerService.fetchStoreName(storeId);
    notifyListeners();
  }

  Future<void> fetchOfferProducts(String offerId) async {
    List<ProductDTO> productDTOs =
        await _offerService.fetchOfferProducts(offerId);
    products =
        productDTOs.map((dto) => ProductModel.fromProductDTO(dto)).toList();
    notifyListeners();
  }

  Future<void> incrementOfferViewCount(String offerId) async {
    await _offerService.incrementOfferViewCount(offerId);
    notifyListeners();
  }
}
