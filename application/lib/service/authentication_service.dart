import 'package:application/model/user_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createUser(UserDTO userDTO) async {
    try {
      final userCredentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: userDTO.email!, password: userDTO.password!);

      await _firestore
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set(userDTO.toFirebaseJson());

      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<bool> loginUser(UserDTO userDTO) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: userDTO.email!, password: userDTO.password!);

      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}
