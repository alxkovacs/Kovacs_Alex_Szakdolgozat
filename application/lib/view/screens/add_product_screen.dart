import 'package:application/model/category_model.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/image_src.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/store_search_screen.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
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
  Widget build(BuildContext context) {
    final addProductScreenViewModel =
        Provider.of<AddProductScreenViewModel>(context);

    return Scaffold(
      body: Center(
        child: addProductScreenViewModel.isLoading
            ? const CustomCircularProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AuthImageWidget(
                          imagePath: ImageSrc.signUpScreenImage,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
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
                        const SizedBox(height: 15),
                        DropdownButtonFormField<CategoryModel>(
                          decoration: AuthInputDecoration(
                            labelText: TranslationEN.category,
                            iconData: Icons.category,
                          ),
                          value: addProductScreenViewModel.selectedCategory,
                          items: categories.map((CategoryModel category) {
                            return DropdownMenuItem<CategoryModel>(
                              value: category,
                              child: Text('${category.emoji} ${category.name}'),
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
                        const SizedBox(height: 15),
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            title: const Text(
                              TranslationEN.store,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 15.0,
                              right: 5.0,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  addProductScreenViewModel.storeName,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                            onTap: () async {
                              final newLocation =
                                  await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const StoreSearchScreen(),
                                ),
                              );
                              if (newLocation != null &&
                                  newLocation is String) {
                                addProductScreenViewModel.enteredStoreName =
                                    newLocation;
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
                        const SizedBox(height: 15),
                        TextFormField(
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
                        const SizedBox(height: 30),
                        CustomElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
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






























// import 'package:application/model/category_model.dart';
// import 'package:application/providers/add_product_view_model_provider.dart';
// import 'package:application/utils/colors.dart';
// import 'package:application/utils/image_src.dart';
// import 'package:application/utils/translation_en.dart';
// import 'package:application/view/screens/store_search_screen.dart';
// import 'package:application/view/widgets/auth_image_widget.dart';
// import 'package:application/view/widgets/auth_input_decoration.dart';
// import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
// import 'package:application/view/widgets/custom_elevated_button.dart';
// import 'package:application/view_model/add_product_screen_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AddProductScreen extends StatefulWidget {
//   const AddProductScreen({super.key});

//   @override
//   State<AddProductScreen> createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   final _formKey = GlobalKey<FormState>();

//   // String _selectedLocation = '';
//   CategoryModel? _selectedCategory;

//   @override
//   void initState() {
//     super.initState();

//     _selectedCategory = categories[0];
//     // _selectedLocation = TranslationEN.chooseLocation;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final addProductScreenViewModel =
//         Provider.of<AddProductScreenViewModel>(context);

//     return Center(
//       child: addProductScreenViewModel.isLoading
//           ? const CustomCircularProgressIndicator()
//           : SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const AuthImageWidget(
//                     imagePath: ImageSrc.signUpScreenImage,
//                   ),
//                   FractionallySizedBox(
//                     widthFactor: 0.8,
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const SizedBox(height: 20),
//                           TextFormField(
//                             decoration: AuthInputDecoration(
//                               labelText: TranslationEN.product,
//                               iconData: Icons.local_offer,
//                             ),
//                             autocorrect: true,
//                             textCapitalization: TextCapitalization.sentences,
//                             validator: (value) {
//                               if (value == null || value.trim().length < 3) {
//                                 return TranslationEN.productValidator;
//                               }

//                               return null;
//                             },
//                             onSaved: (value) {
//                               addProductScreenViewModel.enteredProductName =
//                                   value!;
//                             },
//                           ),
//                           const SizedBox(height: 15),
//                           Material(
//                             color: Colors.transparent,
//                             child: ListTile(
//                               title: const Text(
//                                 TranslationEN.store,
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               contentPadding: const EdgeInsets.only(
//                                 left: 15.0,
//                                 right: 5.0,
//                               ),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     addProductScreenViewModel.storeName,
//                                     style: const TextStyle(
//                                       fontSize: 16.0,
//                                     ),
//                                   ),
//                                   const Icon(Icons.keyboard_arrow_right),
//                                 ],
//                               ),
//                               onTap: () async {
//                                 final newLocation =
//                                     await Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const StoreSearchScreen(),
//                                   ),
//                                 );
//                                 if (newLocation != null) {
//                                   addProductScreenViewModel.enteredStoreName =
//                                       newLocation!;
//                                 }
//                               },
//                               tileColor: AppColor.mainColor.withOpacity(0.05),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 side: const BorderSide(
//                                   color: AppColor.mainColor,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           DropdownButtonFormField<CategoryModel>(
//                             decoration: AuthInputDecoration(
//                               labelText: TranslationEN.category,
//                               iconData: Icons.category,
//                             ),
//                             value: _selectedCategory,
//                             items: categories.map((CategoryModel category) {
//                               return DropdownMenuItem<CategoryModel>(
//                                 value: category,
//                                 child:
//                                     Text('${category.emoji} ${category.name}'),
//                               );
//                             }).toList(),
//                             onChanged: (CategoryModel? newValue) {
//                               setState(() {
//                                 addProductScreenViewModel.enteredCategoryName =
//                                     newValue!.name;
//                                 addProductScreenViewModel.enteredCategoryEmoji =
//                                     newValue.emoji;
//                               });
//                             },
//                             validator: (CategoryModel? value) {
//                               if (value == null) {
//                                 return TranslationEN.chooseCategory;
//                               }
//                               return null;
//                             },
//                             onSaved: (CategoryModel? value) {
//                               addProductScreenViewModel.enteredCategoryName =
//                                   value!.name;
//                               addProductScreenViewModel.enteredCategoryEmoji =
//                                   value.emoji;
//                             },
//                           ),
//                           const SizedBox(height: 15),
//                           TextFormField(
//                             decoration: AuthInputDecoration(
//                               labelText: TranslationEN.price,
//                               iconData: Icons.attach_money,
//                             ),
//                             autocorrect: true,
//                             keyboardType: TextInputType.number,
//                             textCapitalization: TextCapitalization.none,
//                             validator: (value) {
//                               if (value == null || value.trim().isEmpty) {
//                                 return TranslationEN.priceValidator;
//                               }
//                               if (int.tryParse(value.trim()) == null) {
//                                 return TranslationEN.priceIntValidator;
//                               }

//                               return null;
//                             },
//                             onSaved: (value) {
//                               addProductScreenViewModel.enteredPrice =
//                                   int.parse(value!.trim());
//                             },
//                           ),
//                           const SizedBox(height: 30),
//                           CustomElevatedButton(
//                             onPressed: () async {
//                               ScaffoldMessenger.of(context).clearSnackBars();

//                               if (addProductScreenViewModel.storeName ==
//                                       TranslationEN.chooseLocation ||
//                                   addProductScreenViewModel.storeName.isEmpty) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content:
//                                         Text(TranslationEN.chooseLocationFirst),
//                                     backgroundColor: Colors.red,
//                                   ),
//                                 );
//                               } else if (_formKey.currentState!.validate()) {
//                                 _formKey.currentState!.save();

//                                 bool success = await addProductScreenViewModel
//                                     .submitProduct(context);

//                                 if (success) {
//                                   if (mounted) {
//                                     Navigator.pop(context);
//                                   }
//                                 }
//                               }
//                             },
//                             text: TranslationEN.add,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
