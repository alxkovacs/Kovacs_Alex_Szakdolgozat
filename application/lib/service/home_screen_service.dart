import 'package:application/model/user_model.dart';
import 'package:application/utils/translation_en.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchTopViewedProducts() async {
    var snapshot = await _firestore
        .collection('products')
        .orderBy('viewCount', descending: true)
        .limit(9)
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<String> fetchUserName(String userId) async {
    try {
      var docSnapshot = await _firestore.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        UserModel user = UserModel.fromFirestore(docSnapshot);
        return user.firstName!;
      } else {
        return TranslationEN.noData;
      }
    } catch (e) {
      return TranslationEN.error;
    }
  }

  Future<int> getDocumentCount(String collectionPath) async {
    final querySnapshot = await _firestore.collection(collectionPath).get();
    return querySnapshot.docs.length;
  }
}
