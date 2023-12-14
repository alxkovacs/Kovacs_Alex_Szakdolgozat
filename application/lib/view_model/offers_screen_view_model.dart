import 'package:application/model/offer_model.dart';
import 'package:application/service/offers_screen_service.dart';
import 'package:flutter/material.dart';

class OffersScreenViewModel extends ChangeNotifier {
  final OffersScreenService _offerService = OffersScreenService();
  List<OfferModel> mostViewedOffers = [];
  List<OfferModel> offers = [];

  void fetchData() {
    loadMostViewedOffers();
    loadOffers();
    notifyListeners();
  }

  Future<void> loadMostViewedOffers() async {
    final offerDTOs =
        await _offerService.fetchOffers(isOrderRequiredByViewCount: true);
    mostViewedOffers = offerDTOs.map((dto) => OfferModel.fromDTO(dto)).toList();
  }

  Future<void> loadOffers() async {
    final offerDTOs =
        await _offerService.fetchOffers(isOrderRequiredByViewCount: false);
    offers = offerDTOs.map((dto) => OfferModel.fromDTO(dto)).toList();
  }
}
