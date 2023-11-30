import 'package:application/utils/styles/styles.dart';
import 'package:application/utils/translation_en.dart';
import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
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
      decoration: Styles.boxDecorationWithShadow,
      child: Card(
        color: Colors.transparent,
        elevation: 0.0, // Árnyékolás mértéke
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Kerekített sarkok
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Hogy csak a szükséges területet foglalja el
            children: <Widget>[
              FutureBuilder<int>(
                future: getDocumentCount('products'),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomCircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text(TranslationEN.error);
                  } else {
                    return SavingsInfoRow(
                      title: '${TranslationEN.numberOfProducts}:',
                      value:
                          '${snapshot.data} db', // Módosítva az érték megjelenítéséhez
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<int>(
                future: getDocumentCount('stores'),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomCircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text(TranslationEN.error);
                  } else {
                    return SavingsInfoRow(
                      title: '${TranslationEN.numberOfStores}:',
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
