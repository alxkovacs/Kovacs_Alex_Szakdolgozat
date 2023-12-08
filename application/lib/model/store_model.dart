import 'package:application/model/store_dto.dart';

class StoreModel {
  final String id;
  final String name;

  StoreModel({required this.id, required this.name});

  factory StoreModel.fromDTO(StoreDTO dto) {
    return StoreModel(
      id: dto.id,
      name: dto.name,
    );
  }

  StoreDTO toProductDTO() {
    return StoreDTO(
      id: id,
      name: name,
    );
  }
}
