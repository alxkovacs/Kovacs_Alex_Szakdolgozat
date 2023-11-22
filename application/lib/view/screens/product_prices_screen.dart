import 'package:application/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProductPricesScreen extends StatelessWidget {
  final String productId;
  final String storeId;
  final String storeName;

  const ProductPricesScreen({
    Key? key,
    required this.productId,
    required this.storeId,
    required this.storeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          storeName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('productPrices')
            .where('productId', isEqualTo: productId)
            .where('storeId', isEqualTo: storeId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColor.mainColor,
              ),
            ));
          }
          if (snapshot.error != null) {
            return Center(child: Text('Hiba történt a lekérdezés során'));
          }
          // Az adatok megjelenítése, ha a lekérdezés sikeres volt
          final priceList = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          return ListView.builder(
            itemCount: priceList.length,
            itemBuilder: (context, index) {
              final priceItem = priceList[index];
              // A timestamp konvertálása DateTime objektummá
              final DateTime date =
                  (priceItem['timestamp'] as Timestamp).toDate();
              // A dátum formázása év-hónap-nap formátumra
              final String formattedDate =
                  DateFormat('yyyy-MM-dd').format(date);
              // final String formattedDate =
              //     DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

              return ListTile(
                // title: Text('Hozzáadva: $formattedDate'),
                title: Text(
                  formattedDate,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
                trailing: Text(
                  '${priceItem['price']} Ft',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
