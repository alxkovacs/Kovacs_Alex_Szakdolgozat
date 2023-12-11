import 'package:application/model/product_model.dart';
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
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  final ProductModel productModel;

  const ProductScreen({
    Key? key,
    required this.productModel,
  }) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  late TabController _tabController;

  int _enteredPrice = 0;
  String _selectedLocation = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final viewModel =
        Provider.of<ProductScreenViewModel>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      viewModel.incrementViewCount(widget.productModel.id);
      viewModel.checkFavoriteStatus(
          widget.productModel.id, FirebaseAuth.instance.currentUser!.uid);
      viewModel.fetchPrices(widget.productModel.id);
    });
  }

  void updateLocation(String newLocation) {
    setState(() {
      _selectedLocation = newLocation;
    });
  }

  void resetSelectedLocation() {
    setState(() {
      _selectedLocation = TranslationEN.chooseLocation;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildAddPriceTab(ProductScreenViewModel viewModel) {
    return Center(
      child: viewModel.isLoading
          ? const CustomCircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            title: const Text(
                              TranslationEN.store,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(left: 15.0, right: 5.0),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedLocation,
                                  style: const TextStyle(fontSize: 16.0),
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
                              if (newLocation != null) {
                                updateLocation(newLocation);
                              }
                            },
                            tileColor: AppColor.mainColor.withOpacity(0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: AppColor.mainColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: TextFormField(
                          decoration: AuthInputDecoration(
                            labelText: TranslationEN.price,
                            iconData: Icons.attach_money,
                          ),
                          autocorrect: true,
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return TranslationEN.addPriceValidator;
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return TranslationEN.priceIntValidator;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPrice = int.parse(value!.trim());
                          },
                        ),
                      ),
                      CustomElevatedButton(
                        onPressed: () async {
                          if (_form.currentState!.validate()) {
                            _form.currentState!.save();
                            bool result = await viewModel.addPrice(
                              widget.productModel.id,
                              _selectedLocation,
                              _enteredPrice,
                            );
                            if (result) {
                              resetSelectedLocation();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(TranslationEN.priceAdded),
                                ),
                              );
                              if (mounted) {
                                _tabController.animateTo(0);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('${TranslationEN.addPriceError}'),
                                ),
                              );
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductScreenViewModel>(context);

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
                widget.productModel.id, FirebaseAuth.instance.currentUser!.uid),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(208, 229, 236, 1.0),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Text(widget.productModel.emoji,
                  style: const TextStyle(fontSize: 125)),
            ),
          ),
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
                            widget.productModel.product,
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined,
                              size: 45, color: Colors.black),
                          onPressed: () => viewModel.addProductToShoppingList(
                              widget.productModel.id,
                              FirebaseAuth.instance.currentUser!.uid),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.productModel.category,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    dividerColor: AppColor.mainColor.withOpacity(0.5),
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: AppColor.mainColor,
                    labelColor: AppColor.mainColor,
                    unselectedLabelStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    labelStyle: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: TranslationEN.bestOffers),
                      Tab(text: TranslationEN.addPrice),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        viewModel.isDataLoaded
                            ? BestOffersTab(
                                priceAndStoreList: viewModel.prices,
                                productId: widget.productModel.id,
                                isLoading: viewModel.isLoading)
                            : const CustomCircularProgressIndicator(),
                        _buildAddPriceTab(viewModel),
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
