import 'package:application/view/widgets/savings_info_row.dart';
import 'package:flutter/material.dart';

class SavingsCard extends StatelessWidget {
  const SavingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(67, 153, 182, 0.25),
        border: Border.all(
          color: const Color.fromRGBO(67, 153, 182, 1), // Keret színe
          width: 2.5, // Keret vastagsága
        ),
        borderRadius: BorderRadius.circular(
            15), // Keret kerekítése, eznek meg kell egyeznie a Card borderRadius-ával
      ),
      child: Card(
        color: Colors.transparent,
        // color: Colors.white,
        elevation: 0.0, // Árnyékolás mértéke
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Kerekített sarkok
        ),
        child: const Padding(
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
              // További widgetek vagy térköz
            ],
          ),
        ),
      ),
    );
  }
}
