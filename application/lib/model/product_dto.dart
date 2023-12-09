class ProductDTO {
  String id;
  String name;
  String category;
  String emoji;

  ProductDTO({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
  });

  factory ProductDTO.fromFirebaseJson(Map<String, dynamic> json, String docId) {
    return ProductDTO(
      id: docId,
      name: json['name'] ?? '',
      category: json['category']['name'] ?? '',
      emoji: json['category']['emoji'] ?? '',
    );
  }

  Map<String, dynamic> toFirebaseJson() {
    return {
      'name': name,
      'category': {'name': category, 'emoji': emoji},
    };
  }
}
