import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view/widgets/shopping_list_item_card.dart';
import 'package:flutter/material.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  late TabController _tabController;

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
    _tabController = TabController(length: 2, vsync: this);
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

  @override
  Widget build(BuildContext context) {
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
              child: Text('🛒🛍️', style: TextStyle(fontSize: 125)),
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
                    padding:
                        const EdgeInsets.only(left: 25.0, right: 25.0, top: 25),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Különleges ajánlat, Fürdőszoba szett',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
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
                        'Media Markt',
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
                    indicatorColor: const Color.fromRGBO(67, 153, 182, 1.00),
                    labelColor: const Color.fromRGBO(67, 153, 182, 1.00),
                    unselectedLabelStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    labelStyle:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Áttekintés'),
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
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce tincidunt ullamcorper pharetra. Ut lacus ante, faucibus malesuada sollicitudin vel, aliquam eget massa.',
                                style: TextStyle(fontSize: 16),
                              ),
                              // buildBestOffersTab(),
                              SizedBox(height: 20),
                              GridView.builder(
                                shrinkWrap: true, // Add this line
                                physics:
                                    NeverScrollableScrollPhysics(), // And this one
                                // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // Két elem lesz egy sorban
                                  crossAxisSpacing:
                                      30, // vízszintes térköz az elemek között
                                  mainAxisSpacing:
                                      0, // függőleges térköz az elemek között
                                  childAspectRatio: 1, // az elemek aránya
                                ),
                                itemCount: offerItems.length,
                                itemBuilder: (context, index) {
                                  // final item = favorites[index];
                                  return InkWell(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           offerItems[index]['goToPage']()),
                                      // );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .white, // Háttérszín beállítása
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Keret lekerekítése
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromRGBO(
                                                67, 153, 182, 0.5),
                                            // color: Colors.green.shade900,
                                            offset: const Offset(
                                              5.0,
                                              5.0,
                                            ),
                                            blurRadius: 15.0,
                                            spreadRadius: 1.0,
                                          ), //BoxShadow
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: const Offset(0.0, 0.0),
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                          ), //BoxShadow
                                        ],
                                      ),
                                      child: Card(
                                        shadowColor: Colors.transparent,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        elevation: 0.0,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 0,
                                            top: 0,
                                            right: 0,
                                            bottom: 0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // Középre igazítás a függőleges tengely mentén
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center, // Középre igazítás a vízszintes tengely mentén
                                            children: <Widget>[
                                              Text(
                                                offerItems[index]['emoji'],
                                                textAlign: TextAlign
                                                    .center, // Szöveg középre igazítása
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // SizedBox(height: 40),
                              // CustomElevatedButton(
                              //     onPressed: () {},
                              //     text: 'Add a bevásárlólistához'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: Column(
                            children: [
                              for (var item in offerItems)
                                ShoppingListItemCard(
                                  productName: item['name'],
                                  price: item['price'],
                                  store: item['emoji'],
                                  storeName: item['store_name'],
                                ),
                              // SizedBox(height: 20),
                              // CustomElevatedButton(
                              //     onPressed: () {},
                              //     text: 'Add a bevásárlólistához'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 25),
                    child: CustomElevatedButton(
                        onPressed: () {}, text: 'Add a bevásárlólistához'),
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
