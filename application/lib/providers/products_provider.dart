import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Az állapot kezdőértéke üres string lesz.
final searchTermProvider = StateProvider((ref) => '');

// final authStateChangesProvider = StreamProvider<User?>((ref) {
//   return FirebaseAuth.instance.authStateChanges();
// });

final productsProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>(
        (ref, searchTerm) async* {
  // ref.watch(authStateChangesProvider);

  FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  final lowercaseSearchTerm = searchTerm.toLowerCase();

  if (lowercaseSearchTerm.isNotEmpty) {
    stream = _db
        .collection('products')
        .where('name_lowercase', isGreaterThanOrEqualTo: lowercaseSearchTerm)
        .where('name_lowercase',
            isLessThanOrEqualTo: '${lowercaseSearchTerm}\uf8ff')
        .snapshots();
  } else {
    stream = _db.collection('products').snapshots();
  }

  yield* stream.map((snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'product': data['name'] as String?,
          'category': data['category']['name'] as String?,
          'emoji': data['category']['emoji'] as String?,
        };
      }).toList());
});


// final productsProvider =
//     StreamProvider<List<Map<String, dynamic>>>((ref) async* {
//   FirebaseFirestore _db = FirebaseFirestore.instance;
//   yield* _db.collection('products').snapshots().map((snapshot) {
//     return snapshot.docs.map((doc) {
//       return {
//         'id': doc.id,
//         'product': doc.data()['name'] as String,
//         'category': doc.data()['category']['name'] as String,
//         'emoji': doc.data()['category']['emoji'] as String,
//       };
//     }).toList();
//   });
// });