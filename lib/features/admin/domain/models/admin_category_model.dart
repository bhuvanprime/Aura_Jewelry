import 'package:equatable/equatable.dart';

/// Model representing a sub-style within a category (e.g. Solitaire, Choker, Temple)
class AdminCategoryStyle extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  const AdminCategoryStyle({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  AdminCategoryStyle copyWith({
    String? id,
    String? name,
    String? imageUrl,
  }) {
    return AdminCategoryStyle(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory AdminCategoryStyle.fromJson(Map<String, dynamic> json) {
    return AdminCategoryStyle(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id, name, imageUrl];
}

/// Model representing a top-level jewelry category
class AdminCategoryModel extends Equatable {
  final String id;
  final String name;
  final String iconUrl;
  final String bannerUrl;
  final String segment; // 'Women', 'Men', 'Bridal', 'Unisex'
  final List<AdminCategoryStyle> styles;
  final int itemCount;

  const AdminCategoryModel({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.bannerUrl = '',
    this.segment = 'Women',
    this.styles = const [],
    this.itemCount = 0,
  });

  AdminCategoryModel copyWith({
    String? id,
    String? name,
    String? iconUrl,
    String? bannerUrl,
    String? segment,
    List<AdminCategoryStyle>? styles,
    int? itemCount,
  }) {
    return AdminCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      segment: segment ?? this.segment,
      styles: styles ?? this.styles,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  factory AdminCategoryModel.fromJson(Map<String, dynamic> json) {
    return AdminCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      bannerUrl: json['bannerUrl'] ?? '',
      segment: json['segment'] ?? 'Women',
      styles: (json['styles'] as List<dynamic>?)
              ?.map((e) => AdminCategoryStyle.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      itemCount: json['itemCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
      'bannerUrl': bannerUrl,
      'segment': segment,
      'styles': styles.map((s) => s.toJson()).toList(),
      'itemCount': itemCount,
    };
  }

  @override
  List<Object?> get props => [id, name, iconUrl, bannerUrl, segment, styles, itemCount];
}
