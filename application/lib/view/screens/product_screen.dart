import 'package:application/model/price_and_store_model.dart';
import 'package:application/providers/product_view_model_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/screens/store_search_screen.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/best_offers_tab.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/product_screen_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final String id;
  final String product;
  final String category;
  final String emoji;

  const ProductScreen({
    super.key,
    required this.id,
    required this.product,
    required this.category,
    required this.emoji,
  });

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  late TabController _tabController;

  int _enteredPrice = 0;
  String selectedLocation =
      ''; // Egy kezdeti érték, ami látható lesz.; // Kezdeti érték

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final viewModel = ref.read(productViewModelProvider);
    viewModel.onProductAddedToShoppingList = (message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    };
    viewModel.incrementProductViewCount(widget.id);
    viewModel.checkFavoriteStatus(
        widget.id, FirebaseAuth.instance.currentUser?.uid);
  }

  void updateLocation(String newLocation) {
    setState(() {
      selectedLocation = newLocation;
    });
  }

  void resetSelectedLocation() {
    setState(() {
      selectedLocation = TranslationEN.chooseLocation;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(productViewModelProvider);
    AsyncValue<List<PriceAndStoreModel>> priceAndStore =
        ref.watch(priceAndStoreProvider(widget.id));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(208, 229, 236, 1.0),
        scrolledUnderElevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              viewModel.isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 35,
              color: viewModel.isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: () => viewModel.toggleFavorite(
                widget.id, FirebaseAuth.instance.currentUser?.uid),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(208, 229, 236, 1.0),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(widget.emoji, style: const TextStyle(fontSize: 125)),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, right: 25.0, top: 25),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.product,
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 45,
                            color: Colors.black,
                          ),
                          onPressed: () => viewModel.addProductToShoppingList(
                              widget.id,
                              FirebaseAuth.instance.currentUser!.uid),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.category,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TabBar(
                    dividerColor: AppColor.mainColor.withOpacity(0.5),
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: AppColor.mainColor,
                    labelColor: AppColor.mainColor,
                    unselectedLabelStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    labelStyle: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                    controller: _tabController,
                    tabs: const [
                      Tab(text: TranslationEN.bestOffers),
                      Tab(text: TranslationEN.addPrice),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        BestOffersTab(
                            priceAndStore: priceAndStore, productId: widget.id),
                        Center(
                          child: viewModel.isLoading
                              ? const CustomCircularProgressIndicator()
                              : SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Form(
                                          key: _form,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                child: ListTile(
                                                  title: const Text(
                                                    TranslationEN.store,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    left: 15.0,
                                                    right:
                                                        5.0, // Csökkentett jobb oldali padding
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize: MainAxisSize
                                                        .min, // Ez szükséges, hogy a Row ne foglaljon el túl sok helyet
                                                    children: [
                                                      Text(
                                                        selectedLocation, // A kiválasztott helyszín megjelenítése
                                                        style: const TextStyle(
                                                          fontSize:
                                                              16.0, // Állítsd be a kívánt betűméretet
                                                        ),
                                                      ),
                                                      const Icon(Icons
                                                          .keyboard_arrow_right),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    final newLocation =
                                                        await Navigator.of(
                                                                context)
                                                            .push(
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
                                                      .withOpacity(
                                                          0.05), // Háttérszín beállítása
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: const BorderSide(
                                                      color: AppColor.mainColor,
                                                    ),
                                                  ), // Border beállítása hasonlóan az AuthInputDecoration-höz
                                                ),
                                              ),
                                              // ... További widget-ek, mint például gombok
                                              const SizedBox(height: 15),
                                              TextFormField(
                                                decoration: AuthInputDecoration(
                                                  labelText:
                                                      TranslationEN.price,
                                                  iconData: Icons.attach_money,
                                                ),
                                                autocorrect: true,
                                                keyboardType:
                                                    TextInputType.number,
                                                textCapitalization:
                                                    TextCapitalization.none,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return TranslationEN
                                                        .addPriceValidator;
                                                  }
                                                  if (int.tryParse(
                                                          value.trim()) ==
                                                      null) {
                                                    // Ellenőrzi, hogy az érték konvertálható-e int-té
                                                    return TranslationEN
                                                        .priceIntValidator;
                                                  }

                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _enteredPrice =
                                                      int.parse(value!.trim());
                                                },
                                              ),
                                              const SizedBox(height: 30),
                                              CustomElevatedButton(
                                                onPressed: () async {
                                                  ScaffoldMessenger.of(context)
                                                      .clearSnackBars();

                                                  if (selectedLocation ==
                                                          TranslationEN
                                                              .chooseLocation ||
                                                      selectedLocation
                                                          .isEmpty) {
                                                    // Ha igen, megjelenítünk egy Snackbar üzenetet, ami jelzi, hogy először üzletet kell választani
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          TranslationEN
                                                              .chooseLocationFirst,
                                                        ),
                                                        backgroundColor: Colors
                                                            .red, // opcionális: piros háttér a figyelemfelkeltéshez
                                                      ),
                                                    );
                                                  } else {
                                                    // Ellenkező esetben folytatjuk az űrlap ellenőrzését
                                                    if (_form.currentState!
                                                        .validate()) {
                                                      _form.currentState!
                                                          .save();

                                                      // Itt folytatódik az adatok feldolgozása...
                                                      if (_form.currentState!
                                                          .validate()) {
                                                        _form.currentState!
                                                            .save();

                                                        // Adatok megszerzése az űrlapból

                                                        String storeName =
                                                            selectedLocation; // A store nevét az űrlapból kell kiszedni
                                                        int price =
                                                            _enteredPrice; // Már int-ként van tárolva

                                                        try {
                                                          // Termék hozzáadása vagy frissítése az adatbázisban
                                                          await viewModel
                                                              .addPriceWithTimestamp(
                                                            widget.id,
                                                            storeName,
                                                            price, // Átadjuk az int-ként tárolt árat
                                                          );
                                                          resetSelectedLocation(); // Az új függvény hívása, hogy visszaállítsuk az értéket

                                                          // Sikeres hozzáadás esetén visszanavigálunk
                                                          if (mounted) {
                                                            _tabController
                                                                .animateTo(0);
                                                          }
                                                        } catch (e) {
                                                          // Hiba esetén megjelenítünk egy Snackbar üzenetet
                                                          if (mounted) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .clearSnackBars();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    '${TranslationEN.addPriceError}: $e'),
                                                              ),
                                                            );
                                                          }
                                                        } finally {
                                                          // Végül frissítjük az _isLoading állapotot függetlenül a sikertől
                                                        }
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
