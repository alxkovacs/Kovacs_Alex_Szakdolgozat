import 'package:application/utils/colors.dart';
import 'package:application/view/screens/favorites_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                },
              ),
            ),
            Container(
              color: const Color.fromRGBO(67, 153, 182, 0.15),
              child: ListTile(
                visualDensity: VisualDensity(vertical: -2),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                leading: Icon(
                  Icons.favorite,
                  color: const Color.fromRGBO(67, 153, 182, 1.00),
                ),
                title: Text(
                  'Kedvencek',
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
                    MaterialPageRoute(builder: (context) => FavoritesScreen()),
                  );
                },
              ),
            ),
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
                onPressed: () {
                  _firebase.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'start', (Route<dynamic> route) => false);
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
