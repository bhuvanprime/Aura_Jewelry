import 'package:equatable/equatable.dart';

/// Model representing a discount offer / promotional coupon code
class OfferModel extends Equatable {
  final String id;
  final String code;
  final String title;
  final String description;
  final String discountType; // 'percentage' or 'flat'
  final double discountValue; // e.g. 15 (%) or 500 (₹/$)
  final double minOrderValue;
  final double maxDiscount;
  final String validTill;
  final String bannerUrl;
  final bool isActive;
  final int usageCount;

  const OfferModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.minOrderValue = 0,
    this.maxDiscount = 0,
    required this.validTill,
    this.bannerUrl = '',
    this.isActive = true,
    this.usageCount = 0,
  });

  OfferModel copyWith({
    String? id,
    String? code,
    String? title,
    String? description,
    String? discountType,
    double? discountValue,
    double? minOrderValue,
    double? maxDiscount,
    String? validTill,
    String? bannerUrl,
    bool? isActive,
    int? usageCount,
  }) {
    return OfferModel(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      minOrderValue: minOrderValue ?? this.minOrderValue,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      validTill: validTill ?? this.validTill,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      isActive: isActive ?? this.isActive,
      usageCount: usageCount ?? this.usageCount,
    );
  }

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      discountType: json['discountType'] ?? 'percentage',
      discountValue: (json['discountValue'] ?? 0).toDouble(),
      minOrderValue: (json['minOrderValue'] ?? 0).toDouble(),
      maxDiscount: (json['maxDiscount'] ?? 0).toDouble(),
      validTill: json['validTill'] ?? '',
      bannerUrl: json['bannerUrl'] ?? '',
      isActive: json['isActive'] ?? true,
      usageCount: json['usageCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minOrderValue': minOrderValue,
      'maxDiscount': maxDiscount,
      'validTill': validTill,
      'bannerUrl': bannerUrl,
      'isActive': isActive,
      'usageCount': usageCount,
    };
  }

  @override
  List<Object?> get props => [
        id,
        code,
        title,
        description,
        discountType,
        discountValue,
        minOrderValue,
        maxDiscount,
        validTill,
        bannerUrl,
        isActive,
        usageCount,
      ];
}
