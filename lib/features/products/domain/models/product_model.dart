import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String imageUrl;
  final bool isWishlisted;
  final String description;
  final List<String> availableSizes;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.isWishlisted = false,
    this.description = 'No description available.',
    this.availableSizes = const [],
  });

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    double? rating,
    String? imageUrl,
    bool? isWishlisted,
    String? description,
    List<String>? availableSizes,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      description: description ?? this.description,
      availableSizes: availableSizes ?? this.availableSizes,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      isWishlisted: json['isWishlisted'] ?? false,
      description: json['description'] ?? 'No description available.',
      availableSizes: List<String>.from(json['availableSizes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl,
      'isWishlisted': isWishlisted,
      'description': description,
      'availableSizes': availableSizes,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        rating,
        imageUrl,
        isWishlisted,
        description,
        availableSizes,
      ];
}
