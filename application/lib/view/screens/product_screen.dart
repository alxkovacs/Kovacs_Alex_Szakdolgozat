import 'package:application/view/widgets/auth_input_decoration.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  late TabController _tabController;

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
              child: Text('🧹', style: TextStyle(fontSize: 125)),
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
                            'Dyson V15 Detect Absolute',
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
                        'Hálószoba',
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
                        buildBestOffersTab(),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            child: Form(
                              key: _form,
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 30),
                                  TextFormField(
                                    decoration: AuthInputDecoration(
                                      labelText: 'Üzlet',
                                      iconData: Icons.shopping_cart,
                                    ),
                                    autocorrect: true,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().length < 3) {
                                        return 'A névnek legalább 3 karakter hosszúnak kell lennie.';
                                      }

                                      return null;
                                    },
                                    onSaved: (value) {
                                      // _enteredFirstName = value!;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    decoration: AuthInputDecoration(
                                      labelText: 'Ár',
                                      iconData: Icons.attach_money,
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Kérlek valós összeget adj meg.';
                                      }

                                      return null;
                                    },
                                    onSaved: (value) {
                                      // _enteredEmail = value!;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  CustomElevatedButton(
                                    onPressed: () {},
                                    text: 'Hozzáadás',
                                  ),
                                ],
                              ),
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
