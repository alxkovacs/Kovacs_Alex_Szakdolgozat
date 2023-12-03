import 'package:application/view_model/product_prices_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productPricesViewModelProvider =
    ChangeNotifierProvider<ProductPricesScreenViewModel>((ref) {
  return ProductPricesScreenViewModel();
});
