import 'package:equatable/equatable.dart';
import '../../products/domain/models/product_model.dart';
import '../domain/models/admin_category_model.dart';
import '../domain/models/offer_model.dart';
import '../domain/models/combo_model.dart';
import '../domain/models/order_model.dart';
import '../domain/models/gold_rate_model.dart';
import '../domain/models/analytics_model.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {
  final String? message;
  const AdminLoading({this.message});

  @override
  List<Object?> get props => [message];
}

class AdminLoaded extends AdminState {
  final List<ProductModel> products;
  final List<AdminCategoryModel> categories;
  final List<OfferModel> offers;
  final List<ComboModel> combos;
  final List<OrderModel> orders;
  final GoldRateModel goldRates;
  final AdminAnalyticsModel analytics;

  const AdminLoaded({
    required this.products,
    required this.categories,
    required this.offers,
    required this.combos,
    required this.orders,
    required this.goldRates,
    required this.analytics,
  });

  AdminLoaded copyWith({
    List<ProductModel>? products,
    List<AdminCategoryModel>? categories,
    List<OfferModel>? offers,
    List<ComboModel>? combos,
    List<OrderModel>? orders,
    GoldRateModel? goldRates,
    AdminAnalyticsModel? analytics,
  }) {
    return AdminLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      offers: offers ?? this.offers,
      combos: combos ?? this.combos,
      orders: orders ?? this.orders,
      goldRates: goldRates ?? this.goldRates,
      analytics: analytics ?? this.analytics,
    );
  }

  @override
  List<Object?> get props => [
        products,
        categories,
        offers,
        combos,
        orders,
        goldRates,
        analytics,
      ];
}

class AdminOperationSuccess extends AdminState {
  final String message;
  const AdminOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminError extends AdminState {
  final String message;
  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}
