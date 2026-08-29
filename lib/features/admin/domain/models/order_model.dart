import 'package:equatable/equatable.dart';

/// Enum representing the comprehensive lifecycle of a jewelry order
enum OrderLifecycleStatus {
  pending,    // Order placed, awaiting verification/acceptance
  processing, // In workshop / hallmarking / quality check
  shipped,    // Out for transit with luxury armored logistics
  delivered,  // Successfully received by customer
  rejected,   // Declined / Cancelled by store admin or customer
}

extension OrderLifecycleStatusExtension on OrderLifecycleStatus {
  String get displayName {
    switch (this) {
      case OrderLifecycleStatus.pending:
        return 'Pending';
      case OrderLifecycleStatus.processing:
        return 'Processing';
      case OrderLifecycleStatus.shipped:
        return 'Shipped';
      case OrderLifecycleStatus.delivered:
        return 'Delivered';
      case OrderLifecycleStatus.rejected:
        return 'Rejected';
    }
  }

  bool get isActive =>
      this == OrderLifecycleStatus.pending ||
      this == OrderLifecycleStatus.processing ||
      this == OrderLifecycleStatus.shipped;

  bool get isCompleted => this == OrderLifecycleStatus.delivered;

  bool get isRejected => this == OrderLifecycleStatus.rejected;
}

/// Model representing an individual line-item inside an order
class OrderItemModel extends Equatable {
  final String productId;
  final String productName;
  final String imageUrl;
  final double unitPrice;
  final int quantity;
  final String? size;
  final String karat; // e.g. '22K', '18K', '24K'
  final double grossWeightGrams;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    this.size,
    this.karat = '22K',
    this.grossWeightGrams = 12.5,
  });

  double get totalPrice => unitPrice * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      size: json['size'],
      karat: json['karat'] ?? '22K',
      grossWeightGrams: (json['grossWeightGrams'] ?? 12.5).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'size': size,
      'karat': karat,
      'grossWeightGrams': grossWeightGrams,
    };
  }

  @override
  List<Object?> get props => [
        productId,
        productName,
        imageUrl,
        unitPrice,
        quantity,
        size,
        karat,
        grossWeightGrams,
      ];
}

/// Model representing a Customer Order with full tracking & lifecycle status
class OrderModel extends Equatable {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String shippingAddress;
  final List<OrderItemModel> items;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final OrderLifecycleStatus status;
  final String paymentMethod;
  final String paymentStatus; // 'Paid', 'Pending', 'COD'
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? rejectionReason;
  final String? trackingNumber;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.shippingAddress,
    required this.items,
    required this.subtotal,
    this.discountAmount = 0,
    this.taxAmount = 0,
    required this.totalAmount,
    required this.status,
    this.paymentMethod = 'Online Secured UPI/Card',
    this.paymentStatus = 'Paid',
    required this.orderDate,
    this.deliveryDate,
    this.rejectionReason,
    this.trackingNumber,
  });

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? shippingAddress,
    List<OrderItemModel>? items,
    double? subtotal,
    double? discountAmount,
    double? taxAmount,
    double? totalAmount,
    OrderLifecycleStatus? status,
    String? paymentMethod,
    String? paymentStatus,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? rejectionReason,
    String? trackingNumber,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      customerName: json['customerName'] ?? 'Customer',
      customerEmail: json['customerEmail'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      shippingAddress: json['shippingAddress'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: OrderLifecycleStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderLifecycleStatus.pending,
      ),
      paymentMethod: json['paymentMethod'] ?? 'Online Secured',
      paymentStatus: json['paymentStatus'] ?? 'Paid',
      orderDate: json['orderDate'] != null
          ? DateTime.tryParse(json['orderDate']) ?? DateTime.now()
          : DateTime.now(),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.tryParse(json['deliveryDate'])
          : null,
      rejectionReason: json['rejectionReason'],
      trackingNumber: json['trackingNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'shippingAddress': shippingAddress,
      'items': items.map((i) => i.toJson()).toList(),
      'subtotal': subtotal,
      'discountAmount': discountAmount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'status': status.name,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'trackingNumber': trackingNumber,
    };
  }

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        customerName,
        customerEmail,
        customerPhone,
        shippingAddress,
        items,
        subtotal,
        discountAmount,
        taxAmount,
        totalAmount,
        status,
        paymentMethod,
        paymentStatus,
        orderDate,
        deliveryDate,
        rejectionReason,
        trackingNumber,
      ];
}
