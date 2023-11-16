import 'package:application/model/price_and_store.dart';
import 'package:application/model/store.dart';
import 'package:application/providers/price_and_store_provider.dart';
import 'package:application/providers/stores_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view_model/product_view_model.dart';
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

  var _enteredStore = '';
  var _enteredPrice = '';

  Store? _selectedStore;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildBestOffersTab(AsyncValue<List<PriceAndStore>> priceAndStore) {
    return priceAndStore.when(
      loading: () => Center(
        child: Container(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.mainColor),
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
              title: Text(
                priceAndStoreItem
                    .storeName, // A PriceAndStore objektum storeName mezője
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                Icons.add,
                size: 30,
              ),
              subtitle: Text(
                  '${priceAndStoreItem.price} Ft', // A PriceAndStore objektum price mezője
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
    AsyncValue<List<PriceAndStore>> priceAndStore =
        ref.watch(priceAndStoreProvider(widget.id));
    AsyncValue<List<Store>> stores = ref.watch(storesProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(208, 229, 236, 1.0),
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
          SizedBox(height: 30),
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
                          icon: Icon(Icons.favorite_border, size: 45),
                          onPressed: () {
                            // Handle favorite toggling
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                      AppColor.mainColor),
                                ) // Töltés ikon megjelenítése
                              : stores.when(
                                  loading: () =>
                                      const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColor.mainColor),
                                  ),
                                  error: (err, stack) => Text('Error: $err'),
                                  data: (List<Store> stores) {
                                    if (_selectedStore == null &&
                                        stores.isNotEmpty) {
                                      _selectedStore = stores.first;
                                    }
                                    return SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  const SizedBox(height: 20),

                                                  DropdownButtonFormField<
                                                      Store>(
                                                    decoration: InputDecoration(
                                                      labelText: 'Üzlet',
                                                      filled: true,
                                                      fillColor:
                                                          const Color.fromRGBO(
                                                              67,
                                                              153,
                                                              182,
                                                              0.05),
                                                      labelStyle: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                      ),
                                                      suffixIcon: const Icon(
                                                        Icons.store,
                                                        color: Colors.black,
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 15,
                                                              vertical: 15),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide: BorderSide(
                                                            color: const Color
                                                                .fromRGBO(
                                                                67,
                                                                153,
                                                                182,
                                                                1.00)),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide: BorderSide(
                                                            color: const Color
                                                                .fromRGBO(
                                                                67,
                                                                153,
                                                                182,
                                                                1.00)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide: BorderSide(
                                                            color: const Color
                                                                .fromRGBO(
                                                                67,
                                                                153,
                                                                182,
                                                                1.00)),
                                                      ),
                                                    ),
                                                    value:
                                                        _selectedStore, // Ezt az állapotot meg kell határozni
                                                    items: stores
                                                        .map((Store store) {
                                                      return DropdownMenuItem<
                                                          Store>(
                                                        value: store,
                                                        child: Text(
                                                            store.storeName),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (Store? newValue) {
                                                      // Frissítjük az állapotot az új kiválasztott üzlettel.
                                                      // Itt állapotkezelésre van szükség, például a 'setState()' vagy valami Riverpod megoldással.
                                                      setState(() {
                                                        _selectedStore =
                                                            newValue;
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
                                                    decoration:
                                                        AuthInputDecoration(
                                                      labelText: 'Ár',
                                                      iconData:
                                                          Icons.attach_money,
                                                    ),
                                                    autocorrect: true,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textCapitalization:
                                                        TextCapitalization.none,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value
                                                              .trim()
                                                              .isEmpty) {
                                                        return 'Kérlek valós összeget adj meg.';
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
                                                      if (_form.currentState!
                                                          .validate()) {
                                                        setState(() =>
                                                            _isLoading = true);
                                                        _form.currentState!
                                                            .save();
                                                        bool success =
                                                            await viewModel.addPrice(
                                                                widget.id,
                                                                _enteredStore,
                                                                _enteredPrice);

                                                        if (success) {
                                                          if (mounted) {
                                                            _tabController
                                                                .animateTo(0);
                                                          }
                                                        } else {
                                                          if (mounted) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .clearSnackBars();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    'Sikertelen ár hozzáadás!'),
                                                              ),
                                                            );
                                                          }
                                                        }
                                                        await Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  100),
                                                        );
                                                        if (mounted) {
                                                          setState(() =>
                                                              _isLoading =
                                                                  false);
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
