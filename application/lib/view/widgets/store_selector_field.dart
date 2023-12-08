import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';
import 'package:application/view/screens/store_search_screen.dart';
import 'package:application/utils/colors.dart';
import 'package:application/view_model/add_product_screen_view_model.dart';

class StoreSelectorWidget extends StatelessWidget {
  final AddProductScreenViewModel addProductScreenViewModel;

  const StoreSelectorWidget({Key? key, required this.addProductScreenViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          title: const Text(
            TranslationEN.store,
            style: TextStyle(color: Colors.black),
          ),
          contentPadding: const EdgeInsets.only(left: 15.0, right: 5.0),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                addProductScreenViewModel.storeName,
                style: const TextStyle(fontSize: 16.0),
              ),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
          onTap: () async {
            final newLocation = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const StoreSearchScreen(),
              ),
            );
            if (newLocation != null && newLocation is String) {
              addProductScreenViewModel.enteredStoreName = newLocation;
            }
          },
          tileColor: AppColor.mainColor.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: AppColor.mainColor,
            ),
          ),
        ),
      ),
    );
  }
}
