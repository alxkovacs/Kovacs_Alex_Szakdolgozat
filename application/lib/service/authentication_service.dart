import 'package:application/model/user_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:application/model/user_model.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createUser(UserModel userModel) async {
    try {
      final userCredentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: userModel.email!, password: userModel.password!);

      UserDTO userDTO = userModel.toUserDTO();

      await _firestore
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set(userDTO.toFirebaseJson());

      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<bool> loginUser(UserModel userModel) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: userModel.email!, password: userModel.password!);

      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}
