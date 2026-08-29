import 'package:equatable/equatable.dart';
import '../../products/domain/models/product_model.dart';
import '../domain/models/admin_category_model.dart';
import '../domain/models/offer_model.dart';
import '../domain/models/combo_model.dart';
import '../domain/models/order_model.dart';
import '../domain/models/gold_rate_model.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

/// Load entire admin ecosystem
class AdminLoadAllData extends AdminEvent {}

// --- Products ---
class AdminLoadProducts extends AdminEvent {}

class AdminAddProduct extends AdminEvent {
  final ProductModel product;
  const AdminAddProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class AdminUpdateProduct extends AdminEvent {
  final ProductModel product;
  const AdminUpdateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

class AdminDeleteProduct extends AdminEvent {
  final String productId;
  const AdminDeleteProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}

// --- Categories ---
class AdminAddCategory extends AdminEvent {
  final AdminCategoryModel category;
  const AdminAddCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class AdminUpdateCategory extends AdminEvent {
  final AdminCategoryModel category;
  const AdminUpdateCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class AdminDeleteCategory extends AdminEvent {
  final String categoryId;
  const AdminDeleteCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

// --- Offers ---
class AdminAddOffer extends AdminEvent {
  final OfferModel offer;
  const AdminAddOffer(this.offer);

  @override
  List<Object?> get props => [offer];
}

class AdminUpdateOffer extends AdminEvent {
  final OfferModel offer;
  const AdminUpdateOffer(this.offer);

  @override
  List<Object?> get props => [offer];
}

class AdminDeleteOffer extends AdminEvent {
  final String offerId;
  const AdminDeleteOffer(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

class AdminToggleOfferStatus extends AdminEvent {
  final String offerId;
  final bool isActive;
  const AdminToggleOfferStatus(this.offerId, this.isActive);

  @override
  List<Object?> get props => [offerId, isActive];
}

// --- Combos ---
class AdminAddCombo extends AdminEvent {
  final ComboModel combo;
  const AdminAddCombo(this.combo);

  @override
  List<Object?> get props => [combo];
}

class AdminUpdateCombo extends AdminEvent {
  final ComboModel combo;
  const AdminUpdateCombo(this.combo);

  @override
  List<Object?> get props => [combo];
}

class AdminDeleteCombo extends AdminEvent {
  final String comboId;
  const AdminDeleteCombo(this.comboId);

  @override
  List<Object?> get props => [comboId];
}

// --- Orders ---
class AdminUpdateOrderStatus extends AdminEvent {
  final String orderId;
  final OrderLifecycleStatus newStatus;
  final String? rejectionReason;

  const AdminUpdateOrderStatus(
    this.orderId,
    this.newStatus, {
    this.rejectionReason,
  });

  @override
  List<Object?> get props => [orderId, newStatus, rejectionReason];
}

// --- Gold Rates ---
class AdminUpdateGoldRates extends AdminEvent {
  final GoldRateModel rates;
  const AdminUpdateGoldRates(this.rates);

  @override
  List<Object?> get props => [rates];
}

// --- Analytics ---
class AdminLoadAnalytics extends AdminEvent {}
