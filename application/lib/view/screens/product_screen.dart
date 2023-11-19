import 'package:application/model/price_and_store.dart';
import 'package:application/model/store.dart';
import 'package:application/providers/firebase_user_provider.dart';
import 'package:application/providers/price_and_store_provider.dart';
import 'package:application/providers/shopping_list_provider.dart';
import 'package:application/providers/stores_provider.dart';
import 'package:application/services/database_service.dart';
import 'package:application/utils/colors.dart';
import 'package:application/view/screens/store_search_screen.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/product_view_model.dart';
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
  ProductViewModel viewModel = ProductViewModel();
  final _form = GlobalKey<FormState>();
  late TabController _tabController;

  bool _isLoading = false;
  bool _isFavorite = false;

  var _enteredStore = '';
  int _enteredPrice = 0;

  String selectedLocation =
      ''; // Egy kezdeti érték, ami látható lesz.; // Kezdeti érték

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    selectedLocation = 'Válassz helyszínt';

    // Megnöveli a termék megtekintések számát
    final DatabaseService databaseService = DatabaseService();
    databaseService.incrementProductViewCount(widget.id);
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() async {
    final DatabaseService databaseService = DatabaseService();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      // Handle the case when there is no user signed in
      return;
    }
    bool isFav = await databaseService.isProductFavorited(widget.id, userId);
    setState(() {
      _isFavorite = isFav;
    });
  }

  void _toggleFavorite() async {
    setState(() {
      _isLoading = true;
    });
    final DatabaseService databaseService = DatabaseService();
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      // Handle the case when there is no user signed in
      return;
    }
    if (_isFavorite) {
      await databaseService.removeProductFromFavorites(widget.id, userId);
    } else {
      await databaseService.addProductToFavorites(widget.id, userId);
    }
    setState(() {
      _isLoading = false;
      _isFavorite = !_isFavorite;
    });
  }

  void updateLocation(String newLocation) {
    setState(() {
      selectedLocation = newLocation;
    });
  }

  void resetSelectedLocation() {
    setState(() {
      selectedLocation = 'Válassz helyszínt';
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildBestOffersTab(AsyncValue<List<PriceAndStore>> priceAndStore) {
    // final shoppingList = ref.watch(firebaseUserProvider);
    return priceAndStore.when(
      loading: () => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColor.mainColor,
          ),
        ),
      ),
      error: (err, stack) => Text('Error: $err'),
      data: (priceAndStoreList) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          itemCount: priceAndStoreList.length,
          itemBuilder: (context, index) {
            final priceAndStoreItem = priceAndStoreList[index];
            return ListTile(
              leading: Text('${index + 1}.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              title: Text(priceAndStoreItem.storeName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // trailing: IconButton(
              //   icon: Icon(Icons.add),
              //   onPressed: () => ref
              //       .watch(shoppingListProvider.notifier)
              //       .addProductToShoppingList(priceAndStoreItem),
              // ),
              trailing: Text(
                '${priceAndStoreItem.priceCount} db ár alapján',
                style: TextStyle(fontSize: 11),
              ),
              subtitle: Text('${priceAndStoreItem.price} Ft',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54)),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseService = DatabaseService();
    AsyncValue<List<PriceAndStore>> priceAndStore =
        ref.watch(priceAndStoreProvider(widget.id));
    AsyncValue<List<Store>> stores = ref.watch(storesProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(208, 229, 236, 1.0),
        scrolledUnderElevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 35,
              color: _isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(208, 229, 236, 1.0),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(widget.emoji, style: TextStyle(fontSize: 125)),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
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
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            size: 45,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // Handle favorite toggling
                          },
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
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TabBar(
                    dividerColor: const Color.fromRGBO(67, 153, 182, 0.5),
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: const Color.fromRGBO(67, 153, 182, 1.00),
                    labelColor: const Color.fromRGBO(67, 153, 182, 1.00),
                    unselectedLabelStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    labelStyle:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Legjobb Ajánlatok'),
                      Tab(text: 'Ár hozzáadása'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildBestOffersTab(priceAndStore),
                        Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColor.mainColor,
                                  ),
                                ) // Töltés ikon megjelenítése
                              : SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Itt jönnek a többi widget-ek, mint például képek, szövegmezők, stb.

                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Form(
                                          // A _form key-t inicializálni kell a megfelelő helyen
                                          key: _form,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // ... További widget-ek, mint például TextFormField-ek

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
                                                  contentPadding:
                                                      EdgeInsets.only(
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
                                                        style: TextStyle(
                                                          fontSize:
                                                              16.0, // Állítsd be a kívánt betűméretet
                                                        ),
                                                      ),
                                                      Icon(Icons
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
                                                            StoreSearchScreen(),
                                                      ),
                                                    );
                                                    if (newLocation != null) {
                                                      updateLocation(
                                                          newLocation); // Frissítjük a kiválasztott helyszínt
                                                    }
                                                  },
                                                  tileColor: Color.fromRGBO(
                                                      67,
                                                      153,
                                                      182,
                                                      0.05), // Háttérszín beállítása
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: BorderSide(
                                                      color: Color.fromRGBO(
                                                          67, 153, 182, 1.00),
                                                    ),
                                                  ), // Border beállítása hasonlóan az AuthInputDecoration-höz
                                                ),
                                              ),
                                              // ... További widget-ek, mint például gombok
                                              const SizedBox(height: 15),
                                              TextFormField(
                                                decoration: AuthInputDecoration(
                                                  labelText: 'Ár',
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
                                                    return 'Kérlek adj meg egy árat.';
                                                  }
                                                  // if (value.contains(RegExp(r'[^0-9]'))) {
                                                  //   // Ellenőrzi, hogy vannak-e nem-szám karakterek
                                                  //   return 'Csak előjel nélküli egész számok megengedettek.';
                                                  // }
                                                  if (int.tryParse(
                                                          value.trim()) ==
                                                      null) {
                                                    // Ellenőrzi, hogy az érték konvertálható-e int-té
                                                    return 'Kérlek csak előjel nélküli egész számokat adj meg.';
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
                                                          'Válassz helyszínt' ||
                                                      selectedLocation
                                                          .isEmpty) {
                                                    // Ha igen, megjelenítünk egy Snackbar üzenetet, ami jelzi, hogy először üzletet kell választani
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Kérjük, először válasszon üzletet!'),
                                                        backgroundColor: Colors
                                                            .red, // opcionális: piros háttér a figyelemfelkeltéshez
                                                      ),
                                                    );
                                                  } else {
                                                    // Ellenkező esetben folytatjuk az űrlap ellenőrzését
                                                    if (_form.currentState!
                                                        .validate()) {
                                                      setState(() =>
                                                          _isLoading = true);
                                                      _form.currentState!
                                                          .save();

                                                      // Itt folytatódik az adatok feldolgozása...
                                                      if (_form.currentState!
                                                          .validate()) {
                                                        setState(() =>
                                                            _isLoading = true);
                                                        _form.currentState!
                                                            .save();

                                                        // Adatok megszerzése az űrlapból

                                                        String storeName =
                                                            selectedLocation; // A store nevét az űrlapból kell kiszedni
                                                        int price =
                                                            _enteredPrice; // Már int-ként van tárolva

                                                        try {
                                                          // Termék hozzáadása vagy frissítése az adatbázisban
                                                          await _databaseService
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
                                                                    'Hiba történt a termék ár hozzáadása közben: $e'),
                                                              ),
                                                            );
                                                          }
                                                        } finally {
                                                          // Végül frissítjük az _isLoading állapotot függetlenül a sikertől
                                                          if (mounted) {
                                                            setState(() =>
                                                                _isLoading =
                                                                    false);
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
