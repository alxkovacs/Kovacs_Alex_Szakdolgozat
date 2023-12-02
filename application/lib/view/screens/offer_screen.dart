import 'package:application/providers/offer_view_model_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/description_tab.dart';
import 'package:application/view/widgets/products_list.dart';
import 'package:application/view/widgets/store_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfferScreen extends ConsumerStatefulWidget {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String storeId;

  const OfferScreen({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.storeId,
  });

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends ConsumerState<OfferScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // ViewModel lekérdezések
    final viewModel = ref.read(offerViewModelProvider.notifier);
    viewModel.fetchStoreName(widget.storeId);
    viewModel.fetchOfferProducts(widget.id);
    viewModel.incrementOfferViewCount(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(offerViewModelProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(208, 229, 236, 1.0),
      ),
      backgroundColor: const Color.fromRGBO(208, 229, 236, 1.0),
      body: Column(
        children: <Widget>[
          // ... Az emoji és a termék nevének megjelenítése
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                widget.emoji,
                style: const TextStyle(fontSize: 90),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                  // ... további UI elemek
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, right: 25.0, top: 25),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StoreName(storeName: viewModel.storeName),
                  const SizedBox(height: 20),
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
                      Tab(text: TranslationEN.description),
                      Tab(text: TranslationEN.products),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Leírás tab
                        DescriptionTab(widget.description),
                        // Termékek tab
                        ProductsList(products: viewModel.products),
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
