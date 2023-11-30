import 'package:application/view_model/login_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider = ChangeNotifierProvider((ref) {
  return LoginViewModel();
});
