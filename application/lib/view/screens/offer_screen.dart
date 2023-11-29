import 'package:application/services/database_service.dart';
import 'package:application/utils/colors.dart';
import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view/widgets/product_card.dart';
import 'package:application/view/widgets/shopping_list_item_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OfferScreen extends StatefulWidget {
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

class _OfferScreenState extends State<OfferScreen>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  late TabController _tabController;

  String storeName = '';

  final List<Map<String, dynamic>> offerItems = [
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'emoji': '🛋️',
      'store_name': 'Media Markt'
    },
    {
      'name': 'VILEDA Ultramat Turbo felmosó szett',
      'price': '13 890 Ft',
      'emoji': '🪠',
      'store_name': 'Media Markt'
    },
    {
      'name': 'Dyson V15 Detect Absolute',
      'price': '319 990 Ft',
      'emoji': '🧹',
      'store_name': 'Media Markt'
    },
  ];

  @override
  void initState() {
    super.initState();
    // updateStoreName(); // Hívja meg az áruház nevének frissítésére szolgáló függvényt
    _tabController = TabController(length: 2, vsync: this);

    final DatabaseService databaseService = DatabaseService();
    databaseService.incrementOfferViewCount(widget.id);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildBestOffersTab() {
    final List<Map<String, dynamic>> offers = [
      {"name": "Telko", "price": "315 990 Ft"},
      {"name": "Titko", "price": "415 990 Ft"},
      {"name": "Metko", "price": "455 990 Ft"},
      {"name": "Latra", "price": "515 990 Ft"},
      {"name": "Telko", "price": "315 990 Ft"},
      {"name": "Titko", "price": "415 990 Ft"},
      {"name": "Metko", "price": "455 990 Ft"},
      {"name": "Latra", "price": "515 990 Ft"},
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text('${index + 1}.',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          title: Text(
            offers[index]["name"],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(
            Icons.add,
            size: 30,
          ),
          subtitle: Text(offers[index]["price"],
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54)),
        );
      },
    );
  }

  Future<String> getStoreName(String storeId) async {
    var storeDocument = await FirebaseFirestore.instance
        .collection('stores')
        .doc(storeId)
        .get();
    return storeDocument.data()?['name'] ?? 'Ismeretlen áruház';
  }

  Future<List<Map<String, dynamic>>> getOfferProducts(String offerId) async {
    // Lekérdezni az ajánlathoz tartozó termékek azonosítóit
    var offerItemsQuery = await FirebaseFirestore.instance
        .collection('offerItems')
        .where('offerId', isEqualTo: offerId)
        .get();

    // Lekérdezni a termékek részleteit az azonosítók alapján
    List<Map<String, dynamic>> products = [];
    for (var offerItem in offerItemsQuery.docs) {
      var productId = offerItem.data()['productId'];
      var productDocument = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      var productData = productDocument.data();
      if (productData != null) {
        products.add({
          'id': productDocument.id,
          'product': productData['name'] as String?,
          'category': productData['category'] is Map
              ? productData['category']['name'] as String?
              : null,
          'emoji': productData['category'] is Map
              ? productData['category']['emoji'] as String?
              : null,
          // További mezők...
        });
      }
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getStoreName(widget.storeId),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Betöltés jelző az egész képernyőn
          return Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColor.mainColor,
              ),
            )),
          );
        } else if (snapshot.hasError) {
          // Hiba esetén egész oldalas hibaüzenet
          return Scaffold(
            body: Center(child: Text('Hiba történt')),
          );
        } else {
          // Ha az adatok betöltődtek, akkor megjelenítjük a teljes oldalt tartalmazó Scaffoldot
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
                    child: Text(widget.emoji, style: TextStyle(fontSize: 90)),
                  ),
                ),
                SizedBox(height: 10),
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
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.name,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // IconButton(
                              //   icon: Icon(Icons.favorite_border, size: 45),
                              //   onPressed: () {
                              //     // Handle favorite toggling
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              snapshot.data!, // Az áruház neve
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TabBar(
                          dividerColor: const Color.fromRGBO(67, 153, 182, 0.5),
                          unselectedLabelColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor:
                              const Color.fromRGBO(67, 153, 182, 1.00),
                          labelColor: const Color.fromRGBO(67, 153, 182, 1.00),
                          unselectedLabelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          labelStyle: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                          controller: _tabController,
                          tabs: [
                            Tab(text: 'Leírás'),
                            Tab(text: 'Termékek'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 15),
                                child: Column(
                                  children: [
                                    Text(
                                      widget.description,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              FutureBuilder<List<Map<String, dynamic>>>(
                                future: getOfferProducts(widget.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          AppColor.mainColor,
                                        ),
                                      ),
                                    ); // Betöltés jelző
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text(
                                            "Hiba történt a termékek lekérdezésekor."));
                                  } else if (snapshot.hasData) {
                                    return ListView.builder(
                                      shrinkWrap:
                                          true, // Ezzel a ListView nem próbálja meg betölteni az összes elemet azonnal
                                      physics:
                                          ClampingScrollPhysics(), // Ez megakadályozza a "bounce" effektust a scrollban
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, top: 10),
                                          child: ProductCard(
                                            id: snapshot.data![index]['id'],
                                            product: snapshot.data![index]
                                                ['product'],
                                            category: snapshot.data![index]
                                                ['category'],
                                            emoji: snapshot.data![index]
                                                ['emoji'],
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                        child: Text(
                                            "Nincsenek termékek az ajánlathoz."));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 25),
                          child: CustomElevatedButton(
                              onPressed: () {},
                              text: 'Add a bevásárlólistához'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
