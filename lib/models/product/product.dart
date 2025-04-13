// lib/models/product/product.dart

class Product {
  final String id;
  final String productTypeId;
  final String name;
  final String description;
  final double minAmount;
  final double maxAmount;
  final int minTerm;
  final int maxTerm;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.productTypeId,
    required this.name,
    required this.description,
    required this.minAmount,
    required this.maxAmount,
    required this.minTerm,
    required this.maxTerm,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      productTypeId: json['product_type_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      minAmount: double.tryParse(json['min_amount']?.toString() ?? '0') ?? 0,
      maxAmount: double.tryParse(json['max_amount']?.toString() ?? '0') ?? 0,
      minTerm: int.tryParse(json['min_term']?.toString() ?? '0') ?? 0,
      maxTerm: int.tryParse(json['max_term']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
