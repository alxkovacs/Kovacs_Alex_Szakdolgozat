import 'package:application/model/product_dto.dart';

class ProductModel {
  String id;
  String product;
  String category;
  String emoji;
  int viewCount;

  ProductModel({
    required this.id,
    required this.product,
    required this.category,
    required this.emoji,
    this.viewCount = 0,
  });

  factory ProductModel.fromProductDTO(ProductDTO dto) {
    return ProductModel(
      id: dto.id,
      product: dto.name,
      category: dto.category,
      emoji: dto.emoji,
      viewCount: dto.viewCount,
    );
  }

  ProductDTO toProductDTO() {
    return ProductDTO(
      id: id,
      name: product,
      category: category,
      emoji: emoji,
      viewCount: viewCount,
    );
  }
}
