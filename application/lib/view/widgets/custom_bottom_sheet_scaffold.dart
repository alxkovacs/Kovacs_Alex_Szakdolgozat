import 'package:application/utils/colors.dart';
import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/add_product_screen.dart';
import 'package:flutter/material.dart';

class CustomBottomSheetScaffold extends StatelessWidget {
  const CustomBottomSheetScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35.0),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            TranslationEN.addProduct,
            style: Styles.screenCenterTitle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: AppColor.lightBackgroundColor,
        body: const AddProductScreen(),
      ),
    );
  }
}
