import 'package:application/utils/colors.dart';
import 'package:application/view/screens/home_screen.dart';
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
    const HomeScreen(), // A HomeScreen lesz az alapértelmezett oldal
    // ProductScreen(),
    // AddScreen(),
    //
    // SettingsScreen(),
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
      isScrollControlled: true, // Ez teszi teljes magasságúvá a bottom sheet-et
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 2, // A TabBarView-ban lévő oldalak száma
          child: Scaffold(
            appBar: AppBar(
              title: Text('Navigáció'),
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Áruház hozzáadása'),
                  Tab(text: 'Termék hozzáadása'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // Az első oldal tartalma
                Center(child: Text('Áruház hozzáadása oldal')),
                // A második oldal tartalma
                Center(child: Text('Termék hozzáadása oldal')),
              ],
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
