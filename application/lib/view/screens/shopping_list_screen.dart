import 'package:application/view/widgets/product_card.dart';
import 'package:application/view/widgets/savings_card.dart';
import 'package:application/view/widgets/shopping_list_card.dart';
import 'package:application/view/widgets/shopping_list_item_card.dart';
import 'package:flutter/material.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'store': '🛋️',
      'store_name': 'Media Markt'
    },
    {
      'name': 'VILEDA Ultramat Turbo felmosó szett',
      'price': '13 890 Ft',
      'store': '🪠',
      'store_name': 'Media Markt'
    },
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'store': '🧹',
      'store_name': 'Media Markt'
    },
    {
      'name': 'VILEDA Ultramat Turbo felmosó szett',
      'price': '13 890 Ft',
      'store': '🛋️',
      'store_name': 'Media Markt'
    },
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'store': '🪠',
      'store_name': 'Media Markt'
    },
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'store': '🧹',
      'store_name': 'Media Markt'
    },
    {
      'name': 'VILEDA Ultramat Turbo felmosó szett',
      'price': '13 890 Ft',
      'store': '🛋️',
      'store_name': 'Media Markt'
    },
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'store': '🪠',
      'store_name': 'Media Markt'
    },
    // További termékek...
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Bevásárlólista',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        // A görgethető terület itt kezdődik
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Column(
            children: [
              // Termékek listája Column widgetben
              for (var product in products)
                ShoppingListItemCard(
                  productName: product['name'],
                  price: product['price'],
                  store: product['store'],
                  storeName: product['store_name'],
                ),
              SizedBox(height: 20),
              // A TabBar itt már nem része egy Expanded widgetnek
              TabBar(
                // indicatorColor: Colors.white,
                unselectedLabelColor: Colors.black,
                // indicatorPadding: EdgeInsets.all(0),
                dividerColor: const Color.fromRGBO(67, 153, 182, 0.5),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: const Color.fromRGBO(67, 153, 182, 1.00),
                labelColor: const Color.fromRGBO(67, 153, 182, 1.00),
                unselectedLabelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                labelStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: 'Saját lista'),
                  Tab(text: 'Kedvezményes lista'),
                ],
                controller: _tabController,
              ),
              // A TabBarView mérete fix magasságú lehet, vagy egy másik SingleChildScrollView-ben
              Container(
                height: 300, // Adhatsz neki egy fix magasságot
                // height: MediaQuery.of(context).size.height - 200,
                child: TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          const ShoppingListCard(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          const ShoppingListCard(),
                        ],
                      ),
                    ),
                  ],
                  controller: _tabController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
