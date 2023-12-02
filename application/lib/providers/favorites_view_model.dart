import 'package:application/view_model/favorites_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesViewModelProvider =
    ChangeNotifierProvider<FavoritesScreenViewModel>((ref) {
  return FavoritesScreenViewModel();
});
