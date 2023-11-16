import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddProductViewModel {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  Future<bool> addProduct(String enteredProduct, String enteredCategory,
      String enteredStore, String enteredPrice) async {
    try {
      // Create a new document reference with a unique ID
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('products').doc();

      // Use the unique document ID
      String newProductId = docRef.id;

      // Set the data on the new document
      await docRef.set({
        'product': enteredProduct,
        'category': enteredCategory.split('-')[0],
        'emoji': enteredCategory.split('-')[1],
        // You can now also include the newProductId in your document if needed
        // 'id': newProductId,
      });

      await FirebaseFirestore.instance.collection('productPrice').doc().set({
        'productID': newProductId,
        'storeID': enteredStore,
        'price': int.parse(enteredPrice),
      });

      return true; // Sikeres regisztráció
    } catch (err) {
      return false; // Sikertelen regisztráció
    }
  }

  void goToNextScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('signup', (Route<dynamic> route) => false);
  }
}
