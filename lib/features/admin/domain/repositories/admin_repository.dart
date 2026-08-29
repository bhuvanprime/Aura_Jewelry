import '../../../products/domain/models/product_model.dart';
import '../models/admin_category_model.dart';
import '../models/offer_model.dart';
import '../models/combo_model.dart';
import '../models/order_model.dart';
import '../models/gold_rate_model.dart';
import '../models/analytics_model.dart';

/// Comprehensive Administrative Operations Contract
abstract class AdminRepository {
  // --- Products / Items ---
  Future<List<ProductModel>> fetchProducts();
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String productId);

  // --- Categories ---
  Future<List<AdminCategoryModel>> fetchCategories();
  Future<void> addCategory(AdminCategoryModel category);
  Future<void> updateCategory(AdminCategoryModel category);
  Future<void> deleteCategory(String categoryId);

  // --- Offers & Coupons ---
  Future<List<OfferModel>> fetchOffers();
  Future<void> addOffer(OfferModel offer);
  Future<void> updateOffer(OfferModel offer);
  Future<void> deleteOffer(String offerId);
  Future<void> toggleOfferStatus(String offerId, bool isActive);

  // --- Combos & Sets ---
  Future<List<ComboModel>> fetchCombos();
  Future<void> addCombo(ComboModel combo);
  Future<void> updateCombo(ComboModel combo);
  Future<void> deleteCombo(String comboId);

  // --- Orders Lifecycle ---
  Future<List<OrderModel>> fetchOrders();
  Future<void> updateOrderStatus(
    String orderId,
    OrderLifecycleStatus newStatus, {
    String? rejectionReason,
  });
  Future<void> addOrder(OrderModel order);

  // --- Daily Gold Rates ---
  Future<GoldRateModel> fetchGoldRates();
  Future<void> updateGoldRates(GoldRateModel rates);

  // --- Business Analytics ---
  Future<AdminAnalyticsModel> fetchAnalytics();
}
