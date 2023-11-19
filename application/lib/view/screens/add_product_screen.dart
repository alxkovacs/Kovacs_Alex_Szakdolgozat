import 'package:application/model/category.dart';
import 'package:application/services/database_service.dart';
import 'package:application/utils/colors.dart';
import 'package:application/view/screens/store_search_screen.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/add_product_view_model.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final DatabaseService _databaseService = DatabaseService();
  AddProductViewModel viewModel = AddProductViewModel();
  final _form = GlobalKey<FormState>();

  bool _isLoading = false;

  var _enteredProduct = '';
  var _enteredCategory = '';
  // var _enteredStore = '';
  int _enteredPrice = 0; // Kezdőértéknek adjuk meg az 0-t, például

  // String selectedLocation = 'Kőbánya-Kispest'; // Kezdeti érték
  String selectedLocation =
      ''; // Egy kezdeti érték, ami látható lesz.; // Kezdeti érték
  Category? _selectedCategory;
  // Store? _selectedStore;

  @override
  void initState() {
    super.initState();
    // Kezdeti érték beállítása, ha szükséges.

    _selectedCategory = categories[0];
    selectedLocation = 'Válassz helyszínt';
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     // Frissítse a widget állapotát, ha szükséges
    //   });
    // });
  }

  void updateLocation(String newLocation) {
    setState(() {
      selectedLocation = newLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    // AsyncValue<List<Store>> stores = ref.watch(storesProvider);

    return Center(
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.mainColor),
            ) // Töltés ikon megjelenítése
          : SingleChildScrollView(
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
                              iconData: Icons.local_offer,
                            ),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              if (value == null || value.trim().length < 3) {
                                return 'Az üzletnévnek legalább 3 karakter hosszúnak kell lennie.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredProduct = value!;
                            },
                          ),

                          const SizedBox(height: 15),

                          Material(
                            // elevation: 0,
                            color: Colors.transparent,
                            child: ListTile(
                              // key: PageStorageKey<String>('selectedLocationTile'),
                              title: Text(
                                'Üzlet',
                                style: TextStyle(
                                  color: Colors.black,
                                  // fontWeight: FontWeight.w500,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 15.0,
                                right: 5.0, // Csökkentett jobb oldali padding
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Ez szükséges, hogy a Row ne foglaljon el túl sok helyet
                                children: [
                                  Text(
                                    selectedLocation, // A kiválasztott helyszín megjelenítése
                                    style: TextStyle(
                                      fontSize:
                                          16.0, // Állítsd be a kívánt betűméretet
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_right),
                                ],
                              ),
                              onTap: () async {
                                final newLocation =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    // A keresés oldalán valószínűleg valamilyen visszatérési értéket adunk át
                                    builder: (context) => StoreSearchScreen(),
                                  ),
                                );
                                if (newLocation != null) {
                                  updateLocation(
                                      newLocation); // Frissítjük a kiválasztott helyszínt
                                }
                              },
                              tileColor: Color.fromRGBO(
                                  67, 153, 182, 0.05), // Háttérszín beállítása
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Color.fromRGBO(67, 153, 182, 1.00),
                                ),
                              ), // Border beállítása hasonlóan az AuthInputDecoration-höz
                            ),
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
                                    color: Color.fromRGBO(67, 153, 182, 1.00)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(67, 153, 182, 1.00)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(67, 153, 182, 1.00)),
                              ),
                            ),
                            value: _selectedCategory,
                            items: categories.map((Category category) {
                              return DropdownMenuItem<Category>(
                                value: category,
                                child:
                                    Text('${category.emoji} ${category.name}'),
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
                          TextFormField(
                            decoration: AuthInputDecoration(
                              labelText: 'Ár',
                              iconData: Icons.attach_money,
                            ),
                            autocorrect: true,
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Kérlek valós összeget adj meg.';
                              }
                              // if (value.contains(RegExp(r'[^0-9]'))) {
                              //   // Ellenőrzi, hogy vannak-e nem-szám karakterek
                              //   return 'Csak előjel nélküli egész számok megengedettek.';
                              // }
                              if (int.tryParse(value.trim()) == null) {
                                // Ellenőrzi, hogy az érték konvertálható-e int-té
                                return 'Kérlek csak előjel nélküli egész számokat adj meg.';
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

                              if (selectedLocation == 'Válassz helyszínt' ||
                                  selectedLocation.isEmpty) {
                                // Ha igen, megjelenítünk egy Snackbar üzenetet, ami jelzi, hogy először üzletet kell választani
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Kérjük, először válasszon üzletet!'),
                                    backgroundColor: Colors
                                        .red, // opcionális: piros háttér a figyelemfelkeltéshez
                                  ),
                                );
                              } else {
                                // Ellenkező esetben folytatjuk az űrlap ellenőrzését
                                if (_form.currentState!.validate()) {
                                  setState(() => _isLoading = true);
                                  _form.currentState!.save();

                                  // Itt folytatódik az adatok feldolgozása...
                                  if (_form.currentState!.validate()) {
                                    setState(() => _isLoading = true);
                                    _form.currentState!.save();

                                    // Adatok megszerzése az űrlapból
                                    String productName = _enteredProduct;
                                    String categoryName =
                                        _selectedCategory!.name;
                                    String categoryEmoji =
                                        _selectedCategory!.emoji;
                                    String storeName =
                                        selectedLocation; // A store nevét az űrlapból kell kiszedni
                                    int price =
                                        _enteredPrice; // Már int-ként van tárolva

                                    try {
                                      // Termék hozzáadása vagy frissítése az adatbázisban
                                      await _databaseService.addOrUpdateProduct(
                                        productName,
                                        categoryName,
                                        categoryEmoji,
                                        storeName,
                                        price, // Átadjuk az int-ként tárolt árat
                                      );

                                      // Sikeres hozzáadás esetén visszanavigálunk
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    } catch (e) {
                                      // Hiba esetén megjelenítünk egy Snackbar üzenetet
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Hiba történt a termék hozzáadása közben: $e'),
                                          ),
                                        );
                                      }
                                    } finally {
                                      // Végül frissítjük az _isLoading állapotot függetlenül a sikertől
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  }
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
            ),
    );
  }
}
