import 'package:application/utils/colors.dart';
import 'package:application/view/widgets/horizontal_list.dart';
import 'package:application/view/widgets/offers_horizontal_list.dart';
import 'package:application/view/widgets/offers_horizontal_list_smaller.dart';
import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  OffersScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'Ajánlataim',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    // Add padding around the search bar
                    padding: const EdgeInsets.all(0.0),
                    // Use a Material design search bar
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8),
                        hintText: 'Keresés az ajánlatok között...',
                        filled: true, // Ez engedélyezi a háttérszín beállítását
                        fillColor: const Color.fromRGBO(67, 153, 182,
                            0.20), // A háttérszín beállítása kék színre
                        // Adj hozzá egy tiszta gombot a keresősávhoz
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Color.fromRGBO(67, 153, 182, 1.0),
                          ),
                          onPressed: () => _searchController.clear(),
                        ),
                        // Adj hozzá egy kereső ikont vagy gombot a keresősávhoz
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Color.fromRGBO(67, 153, 182, 1.0),
                          ),
                          onPressed: () {
                            // Itt hajts végre keresést
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color.fromRGBO(67, 153, 182, 0.15),
                          ), // A szegély színe piros
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color.fromRGBO(67, 153, 182, 0.15),
                          ), // A szegély színe piros
                        ),
                        // Beállítja a fókuszált szegély színét is pirosra
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: const Color.fromRGBO(67, 153, 182, 0.15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Különleges ajánlatok',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: AppColor.mainColor),
                    ),
                  ),
                ],
              ),
            ),
            OffersHorizontalList(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Legtöbbet megtekintett ajánlatok',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppColor.mainColor),
                ),
              ),
            ),
            // HorizontalList(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kedvencek',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppColor.mainColor),
                ),
              ),
            ),
            OffersHorizontalListSmaller(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Fürdőszoba',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppColor.mainColor),
                ),
              ),
            ),
            OffersHorizontalListSmaller(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
