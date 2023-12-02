import 'package:application/model/category_model.dart';
import 'package:application/providers/add_product_view_model_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/image_src.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/store_search_screen.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  var _enteredProduct = '';
  String _selectedCategoryName = '';
  String _selectedCategoryEmoji = '';
  int _enteredPrice = 0; // Kezdőértéknek adjuk meg az 0-t, például
  String _selectedLocation =
      ''; // Egy kezdeti érték, ami látható lesz.; // Kezdeti érték
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Kezdeti érték beállítása, ha szükséges.

    _selectedCategory = categories[0];
    _selectedLocation = TranslationEN.chooseLocation;
  }

  void updateLocation(String newLocation) {
    setState(() {
      _selectedLocation = newLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addProductViewModelProvider);

    return Center(
      child: viewModel.isLoading
          ? const CustomCircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Itt jönnek a többi widget-ek, mint például képek, szövegmezők, stb.
                  const AuthImageWidget(
                    imagePath: ImageSrc.signUpScreenImage,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: AuthInputDecoration(
                              labelText: TranslationEN.product,
                              iconData: Icons.local_offer,
                            ),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              if (value == null || value.trim().length < 3) {
                                return TranslationEN.productValidator;
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredProduct = value!;
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
                                right: 5.0, // Csökkentett jobb oldali padding
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Ez szükséges, hogy a Row ne foglaljon el túl sok helyet
                                children: [
                                  Text(
                                    _selectedLocation, // A kiválasztott helyszín megjelenítése
                                    style: const TextStyle(
                                      fontSize:
                                          16.0, // Állítsd be a kívánt betűméretet
                                    ),
                                  ),
                                  const Icon(Icons.keyboard_arrow_right),
                                ],
                              ),
                              onTap: () async {
                                final newLocation =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    // A keresés oldalán valószínűleg valamilyen visszatérési értéket adunk át
                                    builder: (context) =>
                                        const StoreSearchScreen(),
                                  ),
                                );
                                if (newLocation != null) {
                                  updateLocation(
                                      newLocation); // Frissítjük a kiválasztott helyszínt
                                }
                              },
                              tileColor: AppColor.mainColor
                                  .withOpacity(0.05), // Háttérszín beállítása
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: AppColor.mainColor,
                                ),
                              ), // Border beállítása hasonlóan az AuthInputDecoration-höz
                            ),
                          ),
                          const SizedBox(height: 15),
                          DropdownButtonFormField<CategoryModel>(
                            decoration: AuthInputDecoration(
                              labelText: TranslationEN.category,
                              iconData: Icons.category,
                            ),
                            value: _selectedCategory,
                            items: categories.map((CategoryModel category) {
                              return DropdownMenuItem<CategoryModel>(
                                value: category,
                                child:
                                    Text('${category.emoji} ${category.name}'),
                              );
                            }).toList(),
                            onChanged: (CategoryModel? newValue) {
                              // Frissítjük az állapotot az új kiválasztott kategóriával.
                              setState(() {
                                _selectedCategoryName = newValue!.name;
                                _selectedCategoryEmoji = newValue.emoji;
                              });
                            },
                            validator: (CategoryModel? value) {
                              if (value == null) {
                                return TranslationEN.chooseCategory;
                              }
                              return null;
                            },
                            onSaved: (CategoryModel? value) {
                              _selectedCategoryName = value!.name;
                              _selectedCategoryEmoji = value.emoji;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: AuthInputDecoration(
                              labelText: TranslationEN.price,
                              iconData: Icons.attach_money,
                            ),
                            autocorrect: true,
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return TranslationEN.priceValidator;
                              }
                              if (int.tryParse(value.trim()) == null) {
                                // Ellenőrzi, hogy az érték konvertálható-e int-té
                                return TranslationEN.priceIntValidator;
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredPrice = int.parse(value!.trim());
                            },
                          ),
                          const SizedBox(height: 30),
                          CustomElevatedButton(
                            onPressed: () async {
                              ScaffoldMessenger.of(context).clearSnackBars();

                              if (_selectedLocation ==
                                      TranslationEN.chooseLocation ||
                                  _selectedLocation.isEmpty) {
                                // Helyszín kiválasztásának ellenőrzése
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text(TranslationEN.chooseLocationFirst),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (_formKey.currentState!.validate()) {
                                // Űrlap validációjának ellenőrzése
                                _formKey.currentState!.save();

                                // Itt folytatódik az adatok feldolgozása...
                                bool success =
                                    await viewModel.addOrUpdateProduct(
                                  _enteredProduct,
                                  _selectedCategoryName,
                                  _selectedCategoryEmoji,
                                  _selectedLocation,
                                  _enteredPrice,
                                );

                                if (success) {
                                  // Sikeres művelet kezelése
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  // Hiba kezelése
                                  if (mounted) {
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            '${TranslationEN.addProductError}!'),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            text: TranslationEN.add,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
