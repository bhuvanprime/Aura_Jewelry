import 'package:equatable/equatable.dart';

/// Model representing a Curated Jewelry Set / Combo (e.g. Royal Bridal Set)
class ComboModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final double originalPrice;
  final double comboPrice;
  final double discountPercent;
  final List<String> includedProductIds;
  final List<String> includedProductNames;
  final String imageUrl;
  final String tag; // 'Bridal Special', 'Festive Trio', 'Wedding Edit'
  final bool inStock;
  final int stockCount;

  const ComboModel({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.comboPrice,
    required this.discountPercent,
    required this.includedProductIds,
    this.includedProductNames = const [],
    required this.imageUrl,
    this.tag = 'Curated Set',
    this.inStock = true,
    this.stockCount = 10,
  });

  ComboModel copyWith({
    String? id,
    String? title,
    String? description,
    double? originalPrice,
    double? comboPrice,
    double? discountPercent,
    List<String>? includedProductIds,
    List<String>? includedProductNames,
    String? imageUrl,
    String? tag,
    bool? inStock,
    int? stockCount,
  }) {
    return ComboModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      originalPrice: originalPrice ?? this.originalPrice,
      comboPrice: comboPrice ?? this.comboPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      includedProductIds: includedProductIds ?? this.includedProductIds,
      includedProductNames: includedProductNames ?? this.includedProductNames,
      imageUrl: imageUrl ?? this.imageUrl,
      tag: tag ?? this.tag,
      inStock: inStock ?? this.inStock,
      stockCount: stockCount ?? this.stockCount,
    );
  }

  factory ComboModel.fromJson(Map<String, dynamic> json) {
    return ComboModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      comboPrice: (json['comboPrice'] ?? 0).toDouble(),
      discountPercent: (json['discountPercent'] ?? 0).toDouble(),
      includedProductIds: List<String>.from(json['includedProductIds'] ?? []),
      includedProductNames: List<String>.from(json['includedProductNames'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
      tag: json['tag'] ?? 'Curated Set',
      inStock: json['inStock'] ?? true,
      stockCount: json['stockCount'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'originalPrice': originalPrice,
      'comboPrice': comboPrice,
      'discountPercent': discountPercent,
      'includedProductIds': includedProductIds,
      'includedProductNames': includedProductNames,
      'imageUrl': imageUrl,
      'tag': tag,
      'inStock': inStock,
      'stockCount': stockCount,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        originalPrice,
        comboPrice,
        discountPercent,
        includedProductIds,
        includedProductNames,
        imageUrl,
        tag,
        inStock,
        stockCount,
      ];
}
