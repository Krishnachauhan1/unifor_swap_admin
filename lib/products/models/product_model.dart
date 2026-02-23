class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String condition; // 'new' or 'used'
  final int stock;
  final int categoryId;
  final int subCategoryId;
  final int sectionId;
  final String? imageUrl;
  final String? schoolName;
  final bool isActive;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.condition,
    required this.stock,
    required this.categoryId,
    required this.subCategoryId,
    required this.sectionId,
    this.imageUrl,
    this.schoolName,
    required this.isActive,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      condition: json['condition'] ?? 'new',
      stock: json['stock'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      subCategoryId: json['sub_category_id'] ?? 0,
      sectionId: json['section_id'] ?? 0,
      imageUrl: json['image_url'],
      schoolName: json['school_name'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}