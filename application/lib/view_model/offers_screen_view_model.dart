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
  }

  Future<void> loadMostViewedOffers() async {
    final offerDTOs = await _offerService.fetchOffers(orderByViewCount: true);
    mostViewedOffers = offerDTOs.map((dto) => OfferModel.fromDTO(dto)).toList();
    notifyListeners();
  }

  Future<void> loadOffers() async {
    final offerDTOs = await _offerService.fetchOffers(orderByViewCount: false);
    offers = offerDTOs.map((dto) => OfferModel.fromDTO(dto)).toList();
    notifyListeners();
  }
}
