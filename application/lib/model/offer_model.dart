import 'package:application/model/offer_dto.dart';

class OfferModel {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String storeId;

  OfferModel({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.storeId,
  });

  factory OfferModel.fromDTO(OfferDTO dto) {
    return OfferModel(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      emoji: dto.emoji,
      storeId: dto.storeId,
    );
  }

  OfferDTO toDTO() {
    return OfferDTO(
      id: id,
      name: name,
      description: description,
      emoji: emoji,
      storeId: storeId,
    );
  }
}
