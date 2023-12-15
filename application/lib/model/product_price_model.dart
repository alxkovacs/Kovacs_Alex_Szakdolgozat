import 'package:application/model/product_price_dto.dart';

class ProductPriceModel {
  final String productId;
  final int price;
  final DateTime timestamp;

  ProductPriceModel({
    required this.productId,
    required this.price,
    required this.timestamp,
  });

  factory ProductPriceModel.fromDTO(ProductPriceDTO dto) {
    return ProductPriceModel(
      productId: dto.productId,
      price: dto.price,
      timestamp: dto.timestamp.toDate(),
    );
  }
}
