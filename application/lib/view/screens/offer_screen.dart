import 'package:application/model/offer_model.dart';
import 'package:application/utils/colors.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:application/view/widgets/description_tab.dart';
import 'package:application/view/widgets/products_list.dart';
import 'package:application/view/widgets/store_name.dart';
import 'package:application/view_model/offer_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfferScreen extends StatefulWidget {
  final OfferModel offerModel;

  const OfferScreen({
    Key? key,
    required this.offerModel,
  }) : super(key: key);

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    Future.microtask(() {
      final offerScreenViewModel =
          Provider.of<OfferScreenViewModel>(context, listen: false);
      offerScreenViewModel.isLoading = true;
      offerScreenViewModel.fetchData(
          widget.offerModel.id, widget.offerModel.storeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final offerScreenViewModel = Provider.of<OfferScreenViewModel>(context);

    if (offerScreenViewModel.isLoading) {
      return const Scaffold(
          backgroundColor: Color.fromRGBO(208, 229, 236, 1.0),
          body: CustomCircularProgressIndicator());
    }

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
              child: Text(
                widget.offerModel.emoji,
                style: const TextStyle(fontSize: 90),
              ),
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
                            widget.offerModel.name,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: StoreName(storeName: offerScreenViewModel.storeName),
                  ),
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
                        DescriptionTab(widget.offerModel.description),
                        ProductsList(products: offerScreenViewModel.products),
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
