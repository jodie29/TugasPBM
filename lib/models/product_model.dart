import 'user_model.dart'; // To reuse ClassModel

class StoreModel {
  final int id;
  final String name;
  final String username;

  StoreModel({required this.id, required this.name, required this.username});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String? createdAt;
  final String? updatedAt;
  final StoreModel? store;
  final ClassModel? classInfo;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.store,
    this.classInfo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse price safely as it might come as a string "32450000.00" or an int/double
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      if (json['price'] is String) {
        parsedPrice = double.tryParse(json['price']) ?? 0.0;
      } else if (json['price'] is num) {
        parsedPrice = (json['price'] as num).toDouble();
      }
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: parsedPrice,
      description: json['description'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      store: json['store'] != null ? StoreModel.fromJson(json['store']) : null,
      classInfo: json['class'] != null ? ClassModel.fromJson(json['class']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price.toInt(), // API expects int for POST
      'description': description,
    };
  }
}
