class ProductDTO {
  String id;
  String name;
  String category;
  String emoji;
  int viewCount;

  ProductDTO({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    this.viewCount = 0,
  });

  factory ProductDTO.fromFirebaseJson(Map<String, dynamic> json, String docId) {
    return ProductDTO(
      id: docId,
      name: json['name'] ?? '',
      category: json['category']['name'] ?? '',
      emoji: json['category']['emoji'] ?? '',
      viewCount: json['viewCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirebaseJson() {
    return {
      'name': name,
      'name_lowercase': name.toLowerCase(),
      'category': {'name': category, 'emoji': emoji},
      'viewCount': viewCount,
    };
  }
}
