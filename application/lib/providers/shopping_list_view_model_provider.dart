import 'package:application/view_model/shopping_list_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shoppingListViewModelProvider =
    ChangeNotifierProvider((ref) => ShoppingListScreenViewModel());
