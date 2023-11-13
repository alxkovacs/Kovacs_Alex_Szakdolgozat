import 'package:application/utils/colors.dart';
import 'package:application/view/screens/add_product_screen.dart';
import 'package:application/view/screens/add_store_screen.dart';
import 'package:application/view/screens/home_screen.dart';
import 'package:application/view/screens/offers_screen.dart';
import 'package:application/view/screens/products_screen.dart';
import 'package:application/view/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0; // Kezdő index a HomeScreen-hez

  // Itt adunk hozzá minden oldalt, amit a BottomNavigationBar használni fog
  final List<Widget> _pages = [
    HomeScreen(), // A HomeScreen lesz az alapértelmezett oldal
    ProductsScreen(),
    Container(), // Ezt az indexet tartjuk fenn az "Hozzáadás" gomb számára
    OffersScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // A "Hozzáadás" gomb indexe 2
      _openBottomSheet(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor:
      //     Colors.white, // Ez biztosítja, hogy a háttér fehér legyen
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: DefaultTabController(
            length: 2, // A TabBarView-ban lévő oldalak száma
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.close), // "X" ikon
                  onPressed: () =>
                      Navigator.pop(context), // Bezárja a ModalBottomSheet-t
                ),
                // title: Text('Navigáció'),
                // További AppBar beállítások...
              ),
              // Itt állíthatod be a Scaffold háttérszínét, ha szükséges
              backgroundColor: Colors.white,
              body: Column(
                children: <Widget>[
                  // A TabBar háttérszínét is beállíthatod, ha szükséges
                  Material(
                    color: Colors.white, // A TabBar háttérszíne
                    child: TabBar(
                      unselectedLabelColor: Colors.black,
                      // indicatorPadding: EdgeInsets.all(0),
                      dividerColor: Colors.transparent,
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
                        Tab(text: 'Termék hozzáadása'),
                        Tab(text: 'Áruház hozzáadása'),
                      ],
                    ),
                  ),
                  const Expanded(
                    // A TabBarView használata az egyes fülek tartalmának megjelenítésére.
                    child: TabBarView(
                      children: [
                        AddProductScreen(),
                        AddStoreScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // Az IndexedStack segít abban, hogy az oldalak állapotát megőrizze
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 12,
        backgroundColor:
            AppColor.mainColor, // A navigációs sáv hátterének színe
        selectedItemColor: Colors.white, // A kijelölt elem színe
        unselectedItemColor: Colors.white, // A nem kijelölt elemek színe
        selectedLabelStyle:
            TextStyle(color: Colors.white), // Kijelölt címke stílusa
        unselectedLabelStyle: TextStyle(
          color: Colors.white,
          // fontWeight: FontWeight.w500,
        ),
        iconSize: 27.0, // Az ikonok mérete
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.home) // Ha a Főoldal van kiválasztva
                : const Icon(
                    Icons.home_outlined), // Ha nem a Főoldal van kiválasztva
            label: 'Főoldal',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Icon(Icons.saved_search) // Ha a Főoldal van kiválasztva
                : Icon(Icons.search), // Ha nem a Főoldal van kiválasztva
            label: 'Termékek',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Hozzáadás',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? Icon(Icons.discount) // Ha a Főoldal van kiválasztva
                : Icon(Icons
                    .discount_outlined), // Ha nem a Főoldal van kiválasztva
            label: 'Ajánlatok',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 4
                ? Icon(Icons.settings) // Ha a Főoldal van kiválasztva
                : Icon(Icons
                    .settings_outlined), // Ha nem a Főoldal van kiválasztva
            label: 'Beállítások',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
