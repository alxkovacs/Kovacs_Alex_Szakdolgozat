class PriceAndStoreDTO {
  final String storeId;
  final String storeName;
  final List<int> prices;

  PriceAndStoreDTO({
    required this.storeId,
    required this.storeName,
    required this.prices,
  });
}
