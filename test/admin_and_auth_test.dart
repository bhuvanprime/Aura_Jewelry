import 'package:flutter_test/flutter_test.dart';
import 'package:aura_luxury_jewelry/core/crypto/admin_credentials.dart';
import 'package:aura_luxury_jewelry/features/admin/domain/models/admin_category_model.dart';
import 'package:aura_luxury_jewelry/features/admin/domain/models/offer_model.dart';
import 'package:aura_luxury_jewelry/features/admin/domain/models/order_model.dart';
import 'package:aura_luxury_jewelry/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:aura_luxury_jewelry/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:aura_luxury_jewelry/core/utils/image_url_resolver.dart';

void main() {
  group('Admin Credentials & Encryption Tests', () {
    test('Verifies encrypted single Master Admin credentials (Admin@acj.com / Admin@123)', () {
      final emailCipher = AdminCredentials.encrypt('admin@acj.com');
      final passCipher = AdminCredentials.encrypt('Admin@123');

      expect(AdminCredentials.decrypt(emailCipher), 'admin@acj.com');
      expect(AdminCredentials.decrypt(passCipher), 'Admin@123');

      expect(AdminCredentials.verify('Admin@acj.com', 'Admin@123'), isTrue);
      expect(AdminCredentials.verify('admin@acj.com', 'Admin@123'), isTrue);
      expect(AdminCredentials.verify('Admin@acj.com', 'WrongPass!'), isFalse);
      expect(AdminCredentials.verify('other@gmail.com', 'Admin@123'), isFalse);
    });

    test('ImageUrlResolver converts Instagram public post link to embeddable image URL', () {
      const igPost = 'https://www.instagram.com/p/DF4a5_xyz/?igsh=MWFqZ3';
      final resolved = ImageUrlResolver.resolve(igPost);
      expect(resolved, 'https://www.instagram.com/p/DF4a5_xyz/media/?size=l');

      const direct = 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d.jpg';
      expect(ImageUrlResolver.resolve(direct), direct);
    });
  });

  group('Admin Domain Models & Repository Tests', () {
    final repo = AdminRepositoryImpl();

    test('Category model serialization and repo fetching', () async {
      final categories = await repo.fetchCategories();
      expect(categories.isNotEmpty, isTrue);

      const cat = AdminCategoryModel(
        id: 'test_cat',
        name: 'Royal Chokers',
        iconUrl: 'https://example.com/icon.png',
        segment: 'Women',
      );
      final json = cat.toJson();
      final fromJson = AdminCategoryModel.fromJson(json);
      expect(fromJson.name, 'Royal Chokers');
    });

    test('Offers & Combos models and repository actions', () async {
      final offers = await repo.fetchOffers();
      expect(offers.isNotEmpty, isTrue);

      final combos = await repo.fetchCombos();
      expect(combos.isNotEmpty, isTrue);

      const offer = OfferModel(
        id: 'off_test',
        code: 'TEST20',
        title: '20% Off',
        description: 'Test discount',
        discountType: 'percentage',
        discountValue: 20,
        validTill: '2026-12-31',
      );
      expect(offer.code, 'TEST20');
      expect(offer.isActive, isTrue);
    });

    test('Order lifecycle transitions and status badge helpers', () async {
      final orders = await repo.fetchOrders();
      expect(orders.isNotEmpty, isTrue);

      final firstOrder = orders.first;
      expect(firstOrder.status.isActive || firstOrder.status.isCompleted || firstOrder.status.isRejected, isTrue);

      await repo.updateOrderStatus(firstOrder.id, OrderLifecycleStatus.delivered);
      final updatedOrders = await repo.fetchOrders();
      final updated = updatedOrders.firstWhere((o) => o.id == firstOrder.id);
      expect(updated.status, OrderLifecycleStatus.delivered);
      expect(updated.status.isCompleted, isTrue);
    });

    test('Live Gold Rates calculation and update', () async {
      final rates = await repo.fetchGoldRates();
      expect(rates.gold22kPerGram, greaterThan(5000));

      final newRates = rates.copyWith(gold22kPerGram: 7950.0);
      await repo.updateGoldRates(newRates);
      final fetched = await repo.fetchGoldRates();
      expect(fetched.gold22kPerGram, 7950.0);
    });

    test('Analytics aggregated intelligence calculation', () async {
      final analytics = await repo.fetchAnalytics();
      expect(analytics.totalRevenue, greaterThan(0));
      expect(analytics.totalOrders, greaterThan(0));
      expect(analytics.totalProducts, greaterThan(0));
    });

    test('Google Sign-In integration executes with customer role', () async {
      final authRepo = AuthRepositoryImpl();
      final user = await authRepo.signInWithGoogle();
      expect(user.role, 'customer');
      expect(user.emailOrPhone.isNotEmpty, isTrue);
    });
  });
}
