import 'package:flutter_bloc/flutter_bloc.dart';
import '../../products/domain/models/product_model.dart';
import '../domain/models/admin_category_model.dart';
import '../domain/models/offer_model.dart';
import '../domain/models/combo_model.dart';
import '../domain/models/order_model.dart';
import '../domain/models/gold_rate_model.dart';
import '../domain/models/analytics_model.dart';
import '../domain/repositories/admin_repository.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;

  AdminBloc({required AdminRepository adminRepository})
      : _adminRepository = adminRepository,
        super(AdminInitial()) {
    on<AdminLoadAllData>(_onLoadAllData);
    on<AdminLoadProducts>(_onLoadAllData);
    on<AdminLoadAnalytics>(_onLoadAllData);

    // Products
    on<AdminAddProduct>(_onAddProduct);
    on<AdminUpdateProduct>(_onUpdateProduct);
    on<AdminDeleteProduct>(_onDeleteProduct);

    // Categories
    on<AdminAddCategory>(_onAddCategory);
    on<AdminUpdateCategory>(_onUpdateCategory);
    on<AdminDeleteCategory>(_onDeleteCategory);

    // Offers
    on<AdminAddOffer>(_onAddOffer);
    on<AdminUpdateOffer>(_onUpdateOffer);
    on<AdminDeleteOffer>(_onDeleteOffer);
    on<AdminToggleOfferStatus>(_onToggleOfferStatus);

    // Combos
    on<AdminAddCombo>(_onAddCombo);
    on<AdminUpdateCombo>(_onUpdateCombo);
    on<AdminDeleteCombo>(_onDeleteCombo);

    // Orders
    on<AdminUpdateOrderStatus>(_onUpdateOrderStatus);

    // Gold Rates
    on<AdminUpdateGoldRates>(_onUpdateGoldRates);
  }

  Future<void> _onLoadAllData(AdminEvent event, Emitter<AdminState> emit) async {
    try {
      final results = await Future.wait([
        _adminRepository.fetchProducts(),
        _adminRepository.fetchCategories(),
        _adminRepository.fetchOffers(),
        _adminRepository.fetchCombos(),
        _adminRepository.fetchOrders(),
        _adminRepository.fetchGoldRates(),
        _adminRepository.fetchAnalytics(),
      ]);

      emit(AdminLoaded(
        products: results[0] as List<ProductModel>,
        categories: results[1] as List<AdminCategoryModel>,
        offers: results[2] as List<OfferModel>,
        combos: results[3] as List<ComboModel>,
        orders: results[4] as List<OrderModel>,
        goldRates: results[5] as GoldRateModel,
        analytics: results[6] as AdminAnalyticsModel,
      ));
    } catch (e) {
      emit(AdminError('Failed to load store data: $e'));
    }
  }

  // --- Products ---
  Future<void> _onAddProduct(AdminAddProduct event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Adding jewelry piece to catalog...'));
    try {
      await _adminRepository.addProduct(event.product);
      emit(const AdminOperationSuccess('Jewelry item added successfully!'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  Future<void> _onUpdateProduct(AdminUpdateProduct event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Updating jewelry item details...'));
    try {
      await _adminRepository.updateProduct(event.product);
      emit(const AdminOperationSuccess('Jewelry item updated successfully!'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  Future<void> _onDeleteProduct(AdminDeleteProduct event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Removing item from inventory...'));
    try {
      await _adminRepository.deleteProduct(event.productId);
      emit(const AdminOperationSuccess('Jewelry item deleted successfully.'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  // --- Categories ---
  Future<void> _onAddCategory(AdminAddCategory event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Creating jewelry category...'));
    try {
      await _adminRepository.addCategory(event.category);
      emit(const AdminOperationSuccess('Category created successfully!'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  Future<void> _onUpdateCategory(AdminUpdateCategory event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Saving category changes...'));
    try {
      await _adminRepository.updateCategory(event.category);
      emit(const AdminOperationSuccess('Category updated successfully!'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  Future<void> _onDeleteCategory(AdminDeleteCategory event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Removing category...'));
    try {
      await _adminRepository.deleteCategory(event.categoryId);
      emit(const AdminOperationSuccess('Category removed.'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  // --- Offers ---
  Future<void> _onAddOffer(AdminAddOffer event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Creating promo coupon...'));
    try {
      await _adminRepository.addOffer(event.offer);
      emit(const AdminOperationSuccess('Offer coupon published successfully!'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  Future<void> _onUpdateOffer(AdminUpdateOffer event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Updating coupon details...'));
    try {
      await _adminRepository.updateOffer(event.offer);
      emit(const AdminOperationSuccess('Offer updated successfully!'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  Future<void> _onDeleteOffer(AdminDeleteOffer event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Removing offer...'));
    try {
      await _adminRepository.deleteOffer(event.offerId);
      emit(const AdminOperationSuccess('Offer deleted.'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  Future<void> _onToggleOfferStatus(AdminToggleOfferStatus event, Emitter<AdminState> emit) async {
    try {
      await _adminRepository.toggleOfferStatus(event.offerId, event.isActive);
      emit(AdminOperationSuccess(event.isActive ? 'Offer activated!' : 'Offer paused.'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  // --- Combos ---
  Future<void> _onAddCombo(AdminAddCombo event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Crafting bridal set combo...'));
    try {
      await _adminRepository.addCombo(event.combo);
      emit(const AdminOperationSuccess('Jewelry combo set published!'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  Future<void> _onUpdateCombo(AdminUpdateCombo event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Updating combo details...'));
    try {
      await _adminRepository.updateCombo(event.combo);
      emit(const AdminOperationSuccess('Combo set updated!'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  Future<void> _onDeleteCombo(AdminDeleteCombo event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Removing combo set...'));
    try {
      await _adminRepository.deleteCombo(event.comboId);
      emit(const AdminOperationSuccess('Combo set removed.'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  // --- Orders Lifecycle ---
  Future<void> _onUpdateOrderStatus(AdminUpdateOrderStatus event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Updating order status...'));
    try {
      await _adminRepository.updateOrderStatus(
        event.orderId,
        event.newStatus,
        rejectionReason: event.rejectionReason,
      );
      emit(AdminOperationSuccess('Order updated to ${event.newStatus.displayName}!'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }

  // --- Gold Rates ---
  Future<void> _onUpdateGoldRates(AdminUpdateGoldRates event, Emitter<AdminState> emit) async {
    emit(const AdminLoading(message: 'Broadcasting live gold rate updates...'));
    try {
      await _adminRepository.updateGoldRates(event.rates);
      emit(const AdminOperationSuccess('Live gold rates updated and synced with customer app!'));
      add(AdminLoadAllData());
    } catch (e) {
      emit(AdminError(e.toString()));
      add(AdminLoadAllData());
    }
  }
}
