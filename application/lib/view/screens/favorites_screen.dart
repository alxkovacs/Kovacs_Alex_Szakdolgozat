import 'package:application/model/favorite.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final List<Favorite> favorites = [
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
    Favorite(
        name: 'Dyson V15 Detect Absolute',
        price: '315 990 Ft',
        store: 'Elektronikai bolt'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Kedvencek',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Két elem lesz egy sorban
          crossAxisSpacing: 0, // vízszintes térköz az elemek között
          mainAxisSpacing: 0, // függőleges térköz az elemek között
          childAspectRatio: 0.8, // az elemek aránya
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final item = favorites[index];
          return Container(
            margin: EdgeInsets.only(
              bottom: 10, // Növeli az utolsó elem alatti térközt
              right: 10,
              left: 10,
              top: 10, // Növeli az első elem feletti térközt
            ), // Térköz a ListTile-ok között
            decoration: BoxDecoration(
              color: Colors.white, // Háttérszín beállítása
              borderRadius: BorderRadius.circular(30.0), // Keret lekerekítése
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(67, 153, 182, 0.5),
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
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 0.0,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  top: 0,
                  right: 10,
                  bottom: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Text(
                          '📺', // Porszívó emoji🫧📺🧹
                          style: TextStyle(
                            fontSize:
                                70.0, // állítsd be a méretet, hogy illeszkedjen a layout-hoz
                          ),
                        ),
                      ),
                    ),
                    Text(
                      item.name, // Termék neve
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${item.price}', // Termék ára
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
