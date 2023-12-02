import 'package:application/view_model/store_search_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storeSearchViewModelProvider =
    ChangeNotifierProvider((ref) => StoreSearchScreenViewModel());
