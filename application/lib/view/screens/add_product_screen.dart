import 'package:application/model/category_model.dart';
import 'package:application/utils/image_src.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view/widgets/store_selector_field.dart';
import 'package:application/view_model/add_product_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final addProductScreenViewModel =
          Provider.of<AddProductScreenViewModel>(context, listen: false);
      addProductScreenViewModel.enteredStoreName = TranslationEN.chooseLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    final addProductScreenViewModel =
        Provider.of<AddProductScreenViewModel>(context);

    return Scaffold(
      body: Center(
        child: addProductScreenViewModel.isLoading
            ? const CustomCircularProgressIndicator()
            : SingleChildScrollView(
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: AuthImageWidget(
                            imagePath: ImageSrc.signUpScreenImage,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            decoration: AuthInputDecoration(
                              labelText: TranslationEN.product,
                              iconData: Icons.local_offer,
                            ),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.sentences,
                            validator:
                                addProductScreenViewModel.validateProductName,
                            onChanged: (value) {
                              addProductScreenViewModel.enteredProductName =
                                  value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: DropdownButtonFormField<CategoryModel>(
                            isExpanded: true,
                            decoration: AuthInputDecoration(
                              labelText: TranslationEN.category,
                              iconData: Icons.category,
                            ),
                            value: addProductScreenViewModel.selectedCategory,
                            items: categories.map((CategoryModel category) {
                              return DropdownMenuItem<CategoryModel>(
                                value: category,
                                child: Text(
                                  '${category.emoji} ${category.name}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (CategoryModel? newValue) {
                              if (newValue != null) {
                                addProductScreenViewModel.enteredCategoryName =
                                    newValue.name;
                                addProductScreenViewModel.enteredCategoryEmoji =
                                    newValue.emoji;
                              }
                            },
                            validator: (CategoryModel? value) {
                              if (value == null) {
                                return TranslationEN.chooseCategory;
                              }
                              return null;
                            },
                          ),
                        ),
                        StoreSelectorField(
                          storeName: addProductScreenViewModel.storeName,
                          onStoreSelected: (String storeName) {
                            addProductScreenViewModel.enteredStoreName =
                                storeName;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: TextFormField(
                            decoration: AuthInputDecoration(
                              labelText: TranslationEN.price,
                              iconData: Icons.attach_money,
                            ),
                            keyboardType: TextInputType.number,
                            validator: addProductScreenViewModel.validatePrice,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                addProductScreenViewModel.enteredPrice =
                                    int.tryParse(value) ?? 0;
                              }
                            },
                          ),
                        ),
                        CustomElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String? storeValidationResult =
                                  addProductScreenViewModel.validateStoreName();
                              if (storeValidationResult != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(storeValidationResult)),
                                );
                                return;
                              }

                              _formKey.currentState!.save();

                              bool success = await addProductScreenViewModel
                                  .submitProduct(context);
                              if (success && mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          text: TranslationEN.add,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
