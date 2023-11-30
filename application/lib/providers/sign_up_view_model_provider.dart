import 'package:application/view_model/sign_up_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpViewModelProvider = ChangeNotifierProvider((ref) {
  return SignUpViewModel();
});
