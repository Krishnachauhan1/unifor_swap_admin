import 'dart:convert';

class ProductModel {
  final int id;
  final int userId;
  final int schoolId;
  final String name;
  final String description;
  final double price;
  final String condition;
  final int stock;
  final List<String> images;
  final bool isApproved;
  final bool isSold;
  final String? schoolName;
  final String? userName;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.userId,
    required this.schoolId,
    required this.name,
    required this.description,
    required this.price,
    required this.condition,
    required this.stock,
    required this.images,
    required this.isApproved,
    required this.isSold,
    this.schoolName,
    this.userName,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      schoolId: json['school_id'] ?? 0,
      name: json['title'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      condition: json['condition'] ?? '',
      stock: json['quantity'] ?? 0,
      images: _parseImages(json['images']),
      isApproved: json['is_approved'] ?? false,
      isSold: json['is_sold'] ?? false,
      schoolName: json['school']?['name'],
      userName: json['user']?['name'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}


List<String> _parseImages(dynamic imagesJson) {
  if (imagesJson == null) {
    return [];
  }

  if (imagesJson is List) {
    return imagesJson.map((e) => e.toString()).toList();
  }

  if (imagesJson is String) {
    try {
      final decoded = jsonDecode(imagesJson);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (e) {
      return [];
    }
  }

  return [];
}