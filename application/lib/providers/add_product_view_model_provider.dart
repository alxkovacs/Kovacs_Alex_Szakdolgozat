import 'package:application/view_model/add_product_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addProductViewModelProvider =
    ChangeNotifierProvider((ref) => AddProductScreenViewModel());
