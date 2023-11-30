import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? firstName;
  String? email;
  // További szükséges mezők...

  UserModel({this.id, this.firstName, this.email});

  // Firestore dokumentumból történő létrehozás
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      firstName: data['firstname'] ?? '',
      email: data['email'] ?? '',
      // További mezők...
    );
  }

  // Firestore-ba való mentéshez
  Map<String, dynamic> toMap() {
    return {
      'firstname': firstName,
      'email': email,
      // További mezők...
    };
  }
}
