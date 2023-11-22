import 'package:application/main.dart';
import 'package:application/providers/favorite_stores_provider.dart';
import 'package:application/providers/price_and_store_provider.dart';
import 'package:application/providers/products_provider.dart';
import 'package:application/providers/user_provider.dart' as user_prov;
import 'package:application/utils/colors.dart';
import 'package:application/view/screens/favorites_screen.dart';
import 'package:application/view/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _firebase = FirebaseAuth.instance;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Beállítások',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Fiók kezelése',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColor.mainColor),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: const Color.fromRGBO(67, 153, 182, 0.15),
              child: ListTile(
                visualDensity: VisualDensity(vertical: -2),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                leading: Icon(
                  Icons.account_circle,
                  color: const Color.fromRGBO(67, 153, 182, 1.00),
                ),
                title: Text(
                  'Profil',
                  style: TextStyle(
                      color: const Color.fromRGBO(67, 153, 182, 1.00),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: const Color.fromRGBO(67, 153, 182, 0.75),
                ),
                onTap: () {
                  // Navigate to profile page or perform action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
              ),
            ),
            // Container(
            //   color: const Color.fromRGBO(67, 153, 182, 0.15),
            //   child: ListTile(
            //     visualDensity: VisualDensity(vertical: -2),
            //     contentPadding:
            //         EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            //     leading: Icon(
            //       Icons.favorite,
            //       color: const Color.fromRGBO(67, 153, 182, 1.00),
            //     ),
            //     title: Text(
            //       'Kedvencek',
            //       style: TextStyle(
            //           color: const Color.fromRGBO(67, 153, 182, 1.00),
            //           fontWeight: FontWeight.bold,
            //           fontSize: 18),
            //     ),
            //     trailing: Icon(
            //       Icons.arrow_forward_ios,
            //       color: const Color.fromRGBO(67, 153, 182, 0.75),
            //     ),
            //     onTap: () {
            //       // Navigate to profile page or perform action
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => FavoritesScreen()),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Beállítások',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColor.mainColor),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: const Color.fromRGBO(67, 153, 182, 0.15),
              child: ListTile(
                visualDensity: VisualDensity(vertical: -2),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                leading: Icon(
                  Icons.dark_mode,
                  color: const Color.fromRGBO(67, 153, 182, 1.00),
                ),
                title: Text(
                  'Sötét mód',
                  style: TextStyle(
                      color: const Color.fromRGBO(67, 153, 182, 1.00),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                trailing: Switch(
                  inactiveTrackColor: const Color.fromRGBO(67, 153, 182, 0.25),
                  inactiveThumbColor: const Color.fromRGBO(67, 153, 182, 1.00),
                  activeTrackColor: const Color.fromRGBO(
                      67, 153, 182, 0.5), // Beállíthatja az aktív track színét
                  activeColor: const Color.fromRGBO(
                      67, 153, 182, 1.00), // Beállíthatja az aktív thumb színét
                  value: false,
                  onChanged: (bool value) {
                    // Toggle dark mode
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: () async {
                  // Felhasználó kijelentkeztetése.
                  await FirebaseAuth.instance.signOut();

                  // Állapotok frissítése a kijelentkezés után.
                  ref.invalidate(user_prov
                      .userProvider); // Ez megsemmisíti a felhasználó állapotát és újraindítja az authStateChanges figyelését.
                  ref.invalidate(
                      favoriteStoresProvider); // Ez újra fogja indítani a favoriteStoresProvider állapotát, ha szükséges.

                  ref.invalidate(priceAndStoreProvider);

                  // Törli a termékekkel kapcsolatos állapotot is, ha van rá szükség.
                  ref.refresh(productsProvider(''));

                  // Navigálás a kezdőképernyőre és az előzmények törlése.
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'start', (Route<dynamic> route) => false);
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(builder: (context) => MyApp()),
                  //     (Route<dynamic> route) => false);
                },
                child: const Text(
                  'Kijelentkezés',
                  style: TextStyle(
                      color: const Color.fromRGBO(67, 153, 182, 1.00),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
