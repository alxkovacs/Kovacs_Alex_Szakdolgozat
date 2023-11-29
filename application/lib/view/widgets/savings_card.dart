import 'package:application/view/widgets/custom_elevated_button.dart';
import 'package:application/view/widgets/savings_info_row.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SavingsCard extends StatelessWidget {
  const SavingsCard({Key? key}) : super(key: key);

  Future<int> getDocumentCount(String collectionPath) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(collectionPath).get();
    return querySnapshot.docs.length;
  }

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
              FutureBuilder<int>(
                future: getDocumentCount('products'),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Hiba történt');
                  } else {
                    return SavingsInfoRow(
                      title: 'Termékek száma:',
                      value:
                          '${snapshot.data} db', // Módosítva az érték megjelenítéséhez
                    );
                  }
                },
              ),
              SizedBox(height: 10),
              FutureBuilder<int>(
                future: getDocumentCount('stores'),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Hiba történt');
                  } else {
                    return SavingsInfoRow(
                      title: 'Üzletek száma:',
                      value: '${snapshot.data} db',
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
