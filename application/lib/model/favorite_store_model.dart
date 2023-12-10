import 'package:application/model/favorite_store_dto.dart';

class FavoriteStoreModel {
  final String id;
  final String name;
  final bool isFavorite;

  FavoriteStoreModel({
    required this.id,
    required this.name,
    required this.isFavorite,
  });

  factory FavoriteStoreModel.fromDTO(FavoriteStoreDTO dto, bool isFavorite) {
    return FavoriteStoreModel(
      id: dto.id,
      name: dto.name,
      isFavorite: isFavorite,
    );
  }
}
