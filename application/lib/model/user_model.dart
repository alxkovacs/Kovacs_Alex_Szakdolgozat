import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? firstName;
  String? email;
  String? password;

  UserModel({this.firstName, this.email});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      firstName: data['firstname'],
      email: data['email'],
    );
  }

  Map<String, dynamic> convertToFirestoreFormat() {
    return {
      'firstname': firstName ?? '',
      'email': email ?? '',
    };
  }
}
