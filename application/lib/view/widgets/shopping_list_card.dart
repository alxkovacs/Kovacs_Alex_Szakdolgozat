import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view/widgets/savings_info_row.dart';
import 'package:application/view/widgets/shopping_list_info_row.dart';
import 'package:flutter/material.dart';

class ShoppingListCard extends StatelessWidget {
  const ShoppingListCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Háttérszín beállítása
        borderRadius: BorderRadius.circular(15.0), // Keret lekerekítése
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
        color: Colors.transparent,
        // color: Colors.white,
        elevation: 0.0, // Árnyékolás mértéke
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Kerekített sarkok
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Hogy csak a szükséges területet foglalja el
            children: <Widget>[
              ShoppingListInfoRow(
                title: 'Cím:',
                value: 'Közép fasor 33\n6726 Szeged',
              ),
              SizedBox(height: 20),
              ShoppingListInfoRow(
                title: 'Üzlet:',
                value: 'Media Markt',
              ),
              SizedBox(height: 20),
              ShoppingListInfoRow(
                title: 'Kedvezmény:',
                value: '- 25 500 Ft',
              ),
              SizedBox(height: 20),
              ShoppingListInfoRow(
                title: 'Végösszeg:',
                value: '153 254 Ft',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
