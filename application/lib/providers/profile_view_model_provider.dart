import 'package:application/view_model/profile_screen_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileViewModelProvider =
    ChangeNotifierProvider((ref) => ProfileScreenViewModel());
