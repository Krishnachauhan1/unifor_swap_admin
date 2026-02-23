class CategoryModel {
  final int id;
  final String name;
  final String icon;
  final String description;
  final List<SubCategoryModel> subCategories;

  CategoryModel({required this.id, required this.name, required this.icon, required this.description, required this.subCategories});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0, name: json['name'] ?? '', icon: json['icon'] ?? '',
      description: json['description'] ?? '',
      subCategories: (json['sub_categories'] as List? ?? []).map((e) => SubCategoryModel.fromJson(e)).toList(),
    );
  }
}

class SubCategoryModel {
  final int id;
  final int categoryId;
  final String name;
  final List<SectionModel> sections;

  SubCategoryModel({required this.id, required this.categoryId, required this.name, required this.sections});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] ?? 0, categoryId: json['category_id'] ?? 0, name: json['name'] ?? '',
      sections: (json['sections'] as List? ?? []).map((e) => SectionModel.fromJson(e)).toList(),
    );
  }
}

class SectionModel {
  final int id;
  final int subCategoryId;
  final String name;
  final int productCount;
  final bool hasNew;
  final bool hasUsed;

  SectionModel({required this.id, required this.subCategoryId, required this.name, required this.productCount, required this.hasNew, required this.hasUsed});

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] ?? 0, subCategoryId: json['sub_category_id'] ?? 0, name: json['name'] ?? '',
      productCount: json['product_count'] ?? 0, hasNew: json['has_new'] ?? false, hasUsed: json['has_used'] ?? false,
    );
  }
}
