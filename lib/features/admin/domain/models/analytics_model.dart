import 'package:equatable/equatable.dart';
import '../../../products/domain/models/product_model.dart';

/// Aggregated Store Performance & Business Intelligence Model
class AdminAnalyticsModel extends Equatable {
  final double totalRevenue;
  final int totalOrders;
  final int activeOrdersCount;
  final int completedOrdersCount;
  final int rejectedOrdersCount;
  final double averageOrderValue;
  final int totalProducts;
  final int totalCategories;
  final int activeOffersCount;
  final int activeCombosCount;
  final List<ProductModel> lowStockProducts;
  final Map<String, int> categoryDistribution;
  final List<MonthlySalesPoint> monthlyRevenue;

  const AdminAnalyticsModel({
    required this.totalRevenue,
    required this.totalOrders,
    required this.activeOrdersCount,
    required this.completedOrdersCount,
    required this.rejectedOrdersCount,
    required this.averageOrderValue,
    required this.totalProducts,
    required this.totalCategories,
    required this.activeOffersCount,
    required this.activeCombosCount,
    required this.lowStockProducts,
    required this.categoryDistribution,
    required this.monthlyRevenue,
  });

  @override
  List<Object?> get props => [
        totalRevenue,
        totalOrders,
        activeOrdersCount,
        completedOrdersCount,
        rejectedOrdersCount,
        averageOrderValue,
        totalProducts,
        totalCategories,
        activeOffersCount,
        activeCombosCount,
        lowStockProducts,
        categoryDistribution,
        monthlyRevenue,
      ];
}

class MonthlySalesPoint extends Equatable {
  final String month;
  final double revenue;
  final int orderCount;

  const MonthlySalesPoint({
    required this.month,
    required this.revenue,
    required this.orderCount,
  });

  @override
  List<Object?> get props => [month, revenue, orderCount];
}
