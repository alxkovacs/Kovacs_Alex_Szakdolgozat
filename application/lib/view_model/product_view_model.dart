import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductViewModel {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  Future<bool> addPrice(
      String productID, String enteredStore, String enteredPrice) async {
    try {
      await FirebaseFirestore.instance.collection('productPrice').doc().set({
        'productID': productID,
        'storeID': enteredStore,
        'price': int.parse(enteredPrice),
      });

      return true; // Sikeres regisztráció
    } catch (err) {
      return false; // Sikertelen regisztráció
    }
  }
}
