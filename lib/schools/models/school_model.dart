class SchoolModel {
  final int id;
  final String name;
  final String? board;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? phone;
  final String? email;
  final String? logo;
  final String? bannerImage;
  final bool isActive;
  final bool isFeatured;

  SchoolModel({
    required this.id,
    required this.name,
    this.board,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.phone,
    this.email,
    this.logo,
    this.bannerImage,
    this.isActive = true,
    this.isFeatured = false,
  });

  String? get locationLine {
    final parts = [city, state]
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  factory SchoolModel.fromJson(Map<String, dynamic> json) => SchoolModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        board: json['board'],
        address: json['address'],
        city: json['city'],
        state: json['state'],
        pincode: json['pincode'],
        phone: json['phone'],
        email: json['email'],
        logo: json['logo'],
        bannerImage: json['banner_image'],
        isActive: json['is_active'] == true || json['is_active'] == 1,
        isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'board': board,
        'address': address,
        'city': city,
        'state': state,
        'pincode': pincode,
        'phone': phone,
        'email': email,
        'is_active': isActive,
        'is_featured': isFeatured,
      };
}
