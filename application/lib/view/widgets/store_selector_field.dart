import 'package:application/utils/translation_en.dart';
import 'package:flutter/material.dart';
import 'package:application/view/screens/store_search_screen.dart';
import 'package:application/utils/colors.dart';

class StoreSelectorField extends StatelessWidget {
  final Function(String) onStoreSelected;
  final String storeName;

  const StoreSelectorField({
    Key? key,
    required this.onStoreSelected,
    required this.storeName,
  }) : super(key: key);

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
                storeName,
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
              onStoreSelected(newLocation);
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
