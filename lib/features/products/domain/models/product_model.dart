import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String imageUrl;
  final List<String> images; // Multiple image URLs (supports Instagram, web URLs, etc.)
  final bool isWishlisted;
  final String description;
  final List<String> availableSizes;
  final String categoryId;
  final String karat; // '22K', '18K', '24K', 'Platinum'
  final double grossWeightGrams;
  final double makingChargesPercent;
  final int stockCount;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.images = const [],
    this.isWishlisted = false,
    this.description = 'No description available.',
    this.availableSizes = const [],
    this.categoryId = 'ring',
    this.karat = '22K',
    this.grossWeightGrams = 8.5,
    this.makingChargesPercent = 10.0,
    this.stockCount = 12,
  });

  /// Returns all available images for slideshow/carousel
  List<String> get allImages {
    if (images.isNotEmpty) return images;
    if (imageUrl.isNotEmpty) return [imageUrl];
    return const [];
  }

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    double? rating,
    String? imageUrl,
    List<String>? images,
    bool? isWishlisted,
    String? description,
    List<String>? availableSizes,
    String? categoryId,
    String? karat,
    double? grossWeightGrams,
    double? makingChargesPercent,
    int? stockCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      description: description ?? this.description,
      availableSizes: availableSizes ?? this.availableSizes,
      categoryId: categoryId ?? this.categoryId,
      karat: karat ?? this.karat,
      grossWeightGrams: grossWeightGrams ?? this.grossWeightGrams,
      makingChargesPercent: makingChargesPercent ?? this.makingChargesPercent,
      stockCount: stockCount ?? this.stockCount,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    List<String> parsedImages = [];
    if (rawImages is List) {
      parsedImages = rawImages.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    }
    final primaryImg = json['imageUrl'] ?? (parsedImages.isNotEmpty ? parsedImages.first : '');

    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: primaryImg,
      images: parsedImages.isNotEmpty ? parsedImages : (primaryImg.isNotEmpty ? [primaryImg] : []),
      isWishlisted: json['isWishlisted'] ?? false,
      description: json['description'] ?? 'No description available.',
      availableSizes: List<String>.from(json['availableSizes'] ?? []),
      categoryId: json['categoryId'] ?? 'ring',
      karat: json['karat'] ?? '22K',
      grossWeightGrams: (json['grossWeightGrams'] ?? 8.5).toDouble(),
      makingChargesPercent: (json['makingChargesPercent'] ?? 10.0).toDouble(),
      stockCount: json['stockCount'] ?? 12,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl.isNotEmpty ? imageUrl : (images.isNotEmpty ? images.first : ''),
      'images': allImages,
      'isWishlisted': isWishlisted,
      'description': description,
      'availableSizes': availableSizes,
      'categoryId': categoryId,
      'karat': karat,
      'grossWeightGrams': grossWeightGrams,
      'makingChargesPercent': makingChargesPercent,
      'stockCount': stockCount,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        rating,
        imageUrl,
        images,
        isWishlisted,
        description,
        availableSizes,
        categoryId,
        karat,
        grossWeightGrams,
        makingChargesPercent,
        stockCount,
      ];
}
