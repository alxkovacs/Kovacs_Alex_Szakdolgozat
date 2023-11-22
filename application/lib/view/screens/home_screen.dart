import 'package:application/providers/home_screen_provider.dart';
import 'package:application/providers/user_provider.dart';
import 'package:application/utils/colors.dart';
import 'package:application/view/screens/favorites_screen.dart';
import 'package:application/view/screens/shopping_list_screen.dart';
import 'package:application/view/widgets/auth_image_widget.dart';
import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view/widgets/horizontal_list.dart';
import 'package:application/view/widgets/savings_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _firebase = FirebaseAuth.instance;

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // var _userFirstName = "";

  final List<Map<String, dynamic>> emojis = [
    {
      'name': 'Bevásárlólista',
      'emoji': '🛒',
      'goToPage': () => ShoppingListScreen(),
    },
    {
      'name': 'Kedvencek',
      'emoji': '❤️',
      'goToPage': () => FavoritesScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor:
    //       const Color.fromRGBO(67, 153, 182, 1.00), // Az új szín.
    // ));
    final userFirstName = ref.watch(userProvider);
    final productsSnapshot = ref.watch(topViewedProductsProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (userFirstName !=
                    null) // Csak akkor jelenítjük meg a felhasználó nevét, ha nem null
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hello, ${userFirstName.firstName}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                const AuthImageWidget(
                  imagePath: 'assets/images/home_screen_image.png',
                ),
                const SavingsCard(),
                const SizedBox(height: 25),
                GridView.builder(
                  shrinkWrap: true, // Add this line
                  physics: NeverScrollableScrollPhysics(), // And this one
                  // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Két elem lesz egy sorban
                    crossAxisSpacing: 10, // vízszintes térköz az elemek között
                    mainAxisSpacing: 0, // függőleges térköz az elemek között
                    childAspectRatio: 4, // az elemek aránya
                  ),
                  itemCount: emojis.length,
                  itemBuilder: (context, index) {
                    // final item = favorites[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  emojis[index]['goToPage']()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // Háttérszín beállítása
                          borderRadius:
                              BorderRadius.circular(10.0), // Keret lekerekítése
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(67, 153, 182, 0.5),
                              // color: Colors.green.shade900,
                              offset: const Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
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
                            borderRadius: BorderRadius.circular(10.0),
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
                                  emojis[index]['name'],
                                  textAlign: TextAlign
                                      .center, // Szöveg középre igazítása
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
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
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Legtöbbet megtekintett termékek',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 15),
                productsSnapshot.when(
                  data: (products) {
                    // Itt adja át a termékek listáját a `HorizontalList` widgetnek.
                    return HorizontalList(products: products);
                  },
                  loading: () => CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColor.mainColor,
                    ),
                  ),
                  error: (e, _) => Text('Hiba: $e'),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Neked ajánlott termékek',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 15),
                productsSnapshot.when(
                  data: (products) {
                    // Itt adja át a termékek listáját a `HorizontalList` widgetnek.
                    return HorizontalList(products: products);
                  },
                  loading: () => CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColor.mainColor,
                    ),
                  ),
                  error: (e, _) => Text('Hiba: $e'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
