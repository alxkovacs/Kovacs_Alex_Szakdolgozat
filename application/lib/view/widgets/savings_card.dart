import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view/widgets/savings_info_row.dart';
import 'package:flutter/material.dart';

class SavingsCard extends StatelessWidget {
  const SavingsCard({Key? key}) : super(key: key);

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
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Hogy csak a szükséges területet foglalja el
            children: <Widget>[
              SavingsInfoRow(
                title: 'Megtakarított pénz:',
                value: '33 560 Ft',
              ),
              SizedBox(height: 10),
              SavingsInfoRow(
                title: 'Összesen:',
                value: '153 254 Ft',
              ),
              // SizedBox(height: 20),
              // ListTile(
              //   leading: Text(
              //     '🛒', // Porszívó emoji
              //     style: TextStyle(
              //       fontSize:
              //           40.0, // állítsd be a méretet, hogy illeszkedjen a layout-hoz
              //     ),
              //   ),
              //   title: Text(
              //     'Bevásárlólista',
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              //   ),
              //   trailing: Icon(Icons.arrow_forward_ios),
              //   onTap: () {
              //     // A kiválasztott elem kezelése
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
