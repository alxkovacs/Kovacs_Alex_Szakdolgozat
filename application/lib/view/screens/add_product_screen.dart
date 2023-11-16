import 'package:application/model/category.dart';
import 'package:application/model/store.dart';
import 'package:application/providers/stores_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/add_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  AddProductViewModel viewModel = AddProductViewModel();
  final _form = GlobalKey<FormState>();

  bool _isLoading = false;

  var _enteredProduct = '';
  var _enteredCategory = '';
  var _enteredStore = '';
  var _enteredPrice = '';

  Category? _selectedCategory;
  Store? _selectedStore;

  @override
  void initState() {
    super.initState();
    // Kezdeti érték beállítása, ha szükséges.
    _selectedCategory = categories[0];
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Store>> stores = ref.watch(storesProvider);

    return Center(
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.mainColor),
            ) // Töltés ikon megjelenítése
          : stores.when(
              loading: () => const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.mainColor),
              ),
              error: (err, stack) => Text('Error: $err'),
              data: (List<Store> stores) {
                if (_selectedStore == null && stores.isNotEmpty) {
                  _selectedStore = stores.first;
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Itt jönnek a többi widget-ek, mint például képek, szövegmezők, stb.
                      const AuthImageWidget(
                        imagePath: 'assets/images/sign_up_screen_image.png',
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          // A _form key-t inicializálni kell a megfelelő helyen
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ... További widget-ek, mint például TextFormField-ek
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: AuthInputDecoration(
                                  labelText: 'Termék',
                                  iconData: Icons.trolley,
                                ),
                                autocorrect: true,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 3) {
                                    return 'Az üzletnévnek legalább 3 karakter hosszúnak kell lennie.';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredProduct = value!;
                                },
                              ),
                              const SizedBox(height: 15),
                              DropdownButtonFormField<Category>(
                                decoration: InputDecoration(
                                  labelText: 'Kategória',
                                  filled: true,
                                  fillColor: Color.fromRGBO(67, 153, 182, 0.05),
                                  labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.category,
                                    color: Colors.black,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(67, 153, 182, 1.00)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(67, 153, 182, 1.00)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(67, 153, 182, 1.00)),
                                  ),
                                ),
                                value: _selectedCategory,
                                items: categories.map((Category category) {
                                  return DropdownMenuItem<Category>(
                                    value: category,
                                    child: Text(
                                        '${category.emoji} ${category.name}'),
                                  );
                                }).toList(),
                                onChanged: (Category? newValue) {
                                  // Frissítjük az állapotot az új kiválasztott kategóriával.
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                                validator: (Category? value) {
                                  if (value == null) {
                                    return 'Kérjük, válasszon egy kategóriát.';
                                  }
                                  return null;
                                },
                                onSaved: (Category? value) {
                                  _enteredCategory =
                                      '${value!.name}-${value.emoji}';
                                },
                              ),
                              const SizedBox(height: 15),
                              DropdownButtonFormField<Store>(
                                decoration: InputDecoration(
                                  labelText: 'Üzlet',
                                  filled: true,
                                  fillColor:
                                      const Color.fromRGBO(67, 153, 182, 0.05),
                                  labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.store,
                                    color: Colors.black,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: const Color.fromRGBO(
                                            67, 153, 182, 1.00)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: const Color.fromRGBO(
                                            67, 153, 182, 1.00)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: const Color.fromRGBO(
                                            67, 153, 182, 1.00)),
                                  ),
                                ),
                                value:
                                    _selectedStore, // Ezt az állapotot meg kell határozni
                                items: stores.map((Store store) {
                                  return DropdownMenuItem<Store>(
                                    value: store,
                                    child: Text(store.storeName),
                                  );
                                }).toList(),
                                onChanged: (Store? newValue) {
                                  // Frissítjük az állapotot az új kiválasztott üzlettel.
                                  // Itt állapotkezelésre van szükség, például a 'setState()' vagy valami Riverpod megoldással.
                                  setState(() {
                                    _selectedStore = newValue;
                                  });
                                },
                                validator: (Store? value) {
                                  if (value == null) {
                                    return 'Kérjük, válasszon egy üzletet.';
                                  }
                                  return null;
                                },
                                onSaved: (Store? value) {
                                  // Itt állapotkezelésre van szükség az érték mentéséhez
                                  _enteredStore = value!.id;
                                },
                              ),
                              // ... További widget-ek, mint például gombok
                              const SizedBox(height: 15),
                              TextFormField(
                                decoration: AuthInputDecoration(
                                  labelText: 'Ár',
                                  iconData: Icons.location_on,
                                ),
                                autocorrect: true,
                                keyboardType: TextInputType.number,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 3) {
                                    return 'A címnek legalább 3 karakter hosszúnak kell lennie.';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPrice = value!;
                                },
                              ),
                              const SizedBox(height: 30),
                              CustomElevatedButton(
                                onPressed: () async {
                                  if (_form.currentState!.validate()) {
                                    setState(() => _isLoading = true);
                                    _form.currentState!.save();
                                    bool success = await viewModel.addProduct(
                                        _enteredProduct,
                                        _enteredCategory,
                                        _enteredStore,
                                        _enteredPrice);

                                    if (success) {
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Sikertelen áruház hozzáadás!'),
                                          ),
                                        );
                                      }
                                    }
                                    await Future.delayed(
                                      const Duration(milliseconds: 100),
                                    );
                                    if (mounted) {
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                },
                                text: 'Hozzáadás',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
