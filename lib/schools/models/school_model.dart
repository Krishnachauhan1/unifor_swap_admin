class SchoolModel {
  final int id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final String? logo;

  SchoolModel({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    this.logo,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) => SchoolModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    address: json['address'],
    phone: json['phone'],
    email: json['email'],
    logo: json['logo'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'phone': phone,
    'email': email,
  };
}
