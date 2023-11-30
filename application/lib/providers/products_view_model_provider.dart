import 'package:application/view_model/products_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsViewModelProvider =
    ChangeNotifierProvider<ProductsScreenViewModel>(
  (ref) => ProductsScreenViewModel(),
);
