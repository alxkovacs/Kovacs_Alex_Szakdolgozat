import 'package:application/view_model/base_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final baseViewModelProvider = ChangeNotifierProvider((ref) {
  return BaseScreenViewModel();
});
