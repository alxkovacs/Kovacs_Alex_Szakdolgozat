import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final homeScreenProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final topViewedProductsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  FirebaseFirestore firestore = ref.watch(homeScreenProvider);

  // A termékek rendezése a viewCount alapján csökkenő sorrendben
  var snapshot = await firestore
      .collection('products')
      .orderBy('viewCount', descending: true)
      .limit(9)
      .get();

  return snapshot.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id; // Hozzáadod az 'id'-t a Map-hez
    return data;
  }).toList();
});

// Ha azonnal kellene frissiteni a listat
// final topViewedProductsStreamProvider =
//     StreamProvider<List<Map<String, dynamic>>>((ref) {
//   FirebaseFirestore firestore = ref.watch(homeScreenProvider);

//   return firestore
//       .collection('products')
//       .orderBy('viewCount', descending: true)
//       .limit(9)
//       .snapshots()
//       .map((snapshot) => snapshot.docs.map((doc) {
//             Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//             data['id'] = doc.id; // Hozzáadod az 'id'-t a Map-hez
//             return data;
//           }).toList());
// });

final nineProductsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  FirebaseFirestore firestore = ref.watch(homeScreenProvider);
  var snapshot = await firestore.collection('products').limit(9).get();

  return snapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
});
