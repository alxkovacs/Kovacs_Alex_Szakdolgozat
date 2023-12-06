import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:application/model/user_model.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createUser(UserModel userModel, String password) async {
    try {
      final userCredentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: userModel.email, password: password);

      await _firestore
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set(userModel.convertToFirestoreFormat());

      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}
