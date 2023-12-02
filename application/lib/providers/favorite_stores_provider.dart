import 'package:application/view_model/favorite_store_search_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteStoresProvider =
    ChangeNotifierProvider<FavoriteStoreScreenViewModel>((ref) {
  return FavoriteStoreScreenViewModel();
});
