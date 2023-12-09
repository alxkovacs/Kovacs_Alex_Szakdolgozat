import 'package:application/model/offer_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OffersScreenService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<OfferDTO>> fetchOffers({bool orderByViewCount = false}) async {
    Query query = _db.collection('offers');
    if (orderByViewCount) {
      query = query.orderBy('viewCount', descending: orderByViewCount);
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => OfferDTO.fromFirestore(doc))
        .toList();
  }
}
