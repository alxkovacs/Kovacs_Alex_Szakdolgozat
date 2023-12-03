import 'package:application/view_model/product_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productViewModelProvider =
    ChangeNotifierProvider<ProductScreenViewModel>((ref) {
  return ProductScreenViewModel();
});
