import 'package:application/view_model/offer_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final offerViewModelProvider =
    ChangeNotifierProvider<OfferScreenViewModel>((ref) {
  return OfferScreenViewModel();
});
