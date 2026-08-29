import 'package:flutter/foundation.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../products/domain/models/product_model.dart';
import '../../domain/models/admin_category_model.dart';
import '../../domain/models/offer_model.dart';
import '../../domain/models/combo_model.dart';
import '../../domain/models/order_model.dart';
import '../../domain/models/gold_rate_model.dart';
import '../../domain/models/analytics_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  // In-memory data caches with default seeds for offline/development mode
  final List<ProductModel> _mockProducts = [
    const ProductModel(
      id: 'prod_1',
      name: 'Nizam Heritage Polki Necklace',
      price: 185000,
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=600&q=80',
      description: 'Handcrafted 22K antique gold choker studded with uncut diamonds and Burmese rubies.',
      availableSizes: ['16 Inch', '18 Inch', '20 Inch'],
      categoryId: 'necklace',
      karat: '22K',
      grossWeightGrams: 48.5,
      makingChargesPercent: 12.0,
      stockCount: 8,
    ),
    const ProductModel(
      id: 'prod_2',
      name: 'Mayur Jhumka Chandbali Earrings',
      price: 64000,
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=600&q=80',
      description: 'Traditional peacock motif gold jhumkas adorned with freshwater pearls and emerald droplets.',
      availableSizes: ['Standard'],
      categoryId: 'earring',
      karat: '22K',
      grossWeightGrams: 16.2,
      makingChargesPercent: 10.5,
      stockCount: 14,
    ),
    const ProductModel(
      id: 'prod_3',
      name: 'Padmavati Royal Solitaire Ring',
      price: 92000,
      rating: 5.0,
      imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=600&q=80',
      description: '18K hallmarked yellow gold ring featuring a certified 1.2 carat brilliant cut VVS1 solitaire.',
      availableSizes: ['6', '7', '8', '9', '10'],
      categoryId: 'ring',
      karat: '18K',
      grossWeightGrams: 6.8,
      makingChargesPercent: 8.0,
      stockCount: 4, // Low stock demo!
    ),
    const ProductModel(
      id: 'prod_4',
      name: 'Kada Rajwada Antique Bangle',
      price: 142000,
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=600&q=80',
      description: 'Heavy 22K temple-engraved gold kada with screw lock mechanism and floral filigree.',
      availableSizes: ['2.4', '2.6', '2.8'],
      categoryId: 'bangle',
      karat: '22K',
      grossWeightGrams: 36.4,
      makingChargesPercent: 11.0,
      stockCount: 3, // Low stock demo!
    ),
    const ProductModel(
      id: 'prod_5',
      name: 'Maharani Bridal Haar Set',
      price: 345000,
      rating: 5.0,
      imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=600&q=80',
      description: 'Opulent multi-layered kundan bridal set with matching earrings and maang tikka.',
      availableSizes: ['Free Size'],
      categoryId: 'bridal',
      karat: '22K',
      grossWeightGrams: 92.0,
      makingChargesPercent: 14.0,
      stockCount: 5,
    ),
  ];

  final List<AdminCategoryModel> _mockCategories = [
    const AdminCategoryModel(
      id: 'necklace',
      name: 'Necklaces & Chokers',
      iconUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=300&q=80',
      bannerUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=800&q=80',
      segment: 'Women',
      styles: [
        AdminCategoryStyle(id: 's1', name: 'Polki Chokers', imageUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=200&q=80'),
        AdminCategoryStyle(id: 's2', name: 'Temple Haar', imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=200&q=80'),
        AdminCategoryStyle(id: 's3', name: 'Modern Diamond Chains', imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=200&q=80'),
      ],
      itemCount: 24,
    ),
    const AdminCategoryModel(
      id: 'earring',
      name: 'Earrings & Jhumkas',
      iconUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=300&q=80',
      bannerUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=800&q=80',
      segment: 'Women',
      styles: [
        AdminCategoryStyle(id: 's4', name: 'Chandbalis', imageUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=200&q=80'),
        AdminCategoryStyle(id: 's5', name: 'Solitaire Studs', imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=200&q=80'),
      ],
      itemCount: 38,
    ),
    const AdminCategoryModel(
      id: 'ring',
      name: 'Rings & Bands',
      iconUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=300&q=80',
      bannerUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=800&q=80',
      segment: 'Women',
      styles: [
        AdminCategoryStyle(id: 's6', name: 'Engagement Solitaires', imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=200&q=80'),
        AdminCategoryStyle(id: 's7', name: 'Antique Cocktail Rings', imageUrl: 'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?auto=format&fit=crop&w=200&q=80'),
      ],
      itemCount: 42,
    ),
    const AdminCategoryModel(
      id: 'bangle',
      name: 'Bangles & Kadas',
      iconUrl: 'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=300&q=80',
      bannerUrl: 'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=800&q=80',
      segment: 'Women',
      styles: [
        AdminCategoryStyle(id: 's8', name: 'Antique Kadas', imageUrl: 'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=200&q=80'),
        AdminCategoryStyle(id: 's9', name: 'Diamond Tennis Bangles', imageUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=200&q=80'),
      ],
      itemCount: 19,
    ),
    const AdminCategoryModel(
      id: 'bridal',
      name: 'Royal Bridal Trousseau',
      iconUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=300&q=80',
      bannerUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=800&q=80',
      segment: 'Bridal',
      styles: [
        AdminCategoryStyle(id: 's10', name: 'Complete Trousseau Sets', imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=200&q=80'),
        AdminCategoryStyle(id: 's11', name: 'Maang Tikkas & Matha Patti', imageUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=200&q=80'),
      ],
      itemCount: 15,
    ),
  ];

  final List<OfferModel> _mockOffers = [
    const OfferModel(
      id: 'off_1',
      code: 'ROYAL15',
      title: 'Imperial Festive 15% Off',
      description: 'Get 15% discount on all 22K Gold & Polki Necklaces.',
      discountType: 'percentage',
      discountValue: 15.0,
      minOrderValue: 50000,
      maxDiscount: 25000,
      validTill: '2026-12-31',
      bannerUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=600&q=80',
      isActive: true,
      usageCount: 142,
    ),
    const OfferModel(
      id: 'off_2',
      code: 'BRIDALGOLD',
      title: 'Flat ₹10,000 Off Bridal Sets',
      description: 'Flat savings on orders above ₹2,00,000 for wedding sets.',
      discountType: 'flat',
      discountValue: 10000.0,
      minOrderValue: 200000,
      maxDiscount: 10000,
      validTill: '2026-11-30',
      bannerUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=600&q=80',
      isActive: true,
      usageCount: 68,
    ),
    const OfferModel(
      id: 'off_3',
      code: 'DIAMOND20',
      title: '20% Off Making Charges',
      description: 'Enjoy 20% off on craftsmanship on diamond solitaire rings.',
      discountType: 'percentage',
      discountValue: 20.0,
      minOrderValue: 75000,
      maxDiscount: 15000,
      validTill: '2026-10-15',
      bannerUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=600&q=80',
      isActive: false,
      usageCount: 89,
    ),
  ];

  final List<ComboModel> _mockCombos = [
    const ComboModel(
      id: 'combo_1',
      title: 'Imperial Nizam Bridal Suite',
      description: 'Heritage 22K Polki Necklace + Matching Peacock Jhumkas + Kada Bangles',
      originalPrice: 391000,
      comboPrice: 345000,
      discountPercent: 11.7,
      includedProductIds: ['prod_1', 'prod_2', 'prod_4'],
      includedProductNames: [
        'Nizam Heritage Polki Necklace',
        'Mayur Jhumka Chandbali Earrings',
        'Kada Rajwada Antique Bangle',
      ],
      imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=600&q=80',
      tag: 'Bridal Special',
      inStock: true,
      stockCount: 6,
    ),
    const ComboModel(
      id: 'combo_2',
      title: 'Padmavati Solitaire & Jhumka Duo',
      description: '18K VVS1 Solitaire Ring + 22K Chandbali Earrings Pairing',
      originalPrice: 156000,
      comboPrice: 139000,
      discountPercent: 10.8,
      includedProductIds: ['prod_2', 'prod_3'],
      includedProductNames: [
        'Mayur Jhumka Chandbali Earrings',
        'Padmavati Royal Solitaire Ring',
      ],
      imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=600&q=80',
      tag: 'Festive Duo',
      inStock: true,
      stockCount: 9,
    ),
  ];

  final List<OrderModel> _mockOrders = [
    OrderModel(
      id: 'ord_1001',
      orderNumber: 'AURA-2026-9812',
      customerName: 'Maharani Rajeshwari Devi',
      customerEmail: 'rajeshwari.devi@heritage.in',
      customerPhone: '+91 98450 12345',
      shippingAddress: 'Palace Gardens, 4th Cross, Civil Lines, Jaipur, RJ - 302006',
      items: const [
        OrderItemModel(
          productId: 'prod_1',
          productName: 'Nizam Heritage Polki Necklace',
          imageUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=600&q=80',
          unitPrice: 185000,
          quantity: 1,
          size: '18 Inch',
          karat: '22K',
          grossWeightGrams: 48.5,
        ),
        OrderItemModel(
          productId: 'prod_2',
          productName: 'Mayur Jhumka Chandbali Earrings',
          imageUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=600&q=80',
          unitPrice: 64000,
          quantity: 1,
          size: 'Standard',
          karat: '22K',
          grossWeightGrams: 16.2,
        ),
      ],
      subtotal: 249000,
      discountAmount: 15000,
      taxAmount: 7020,
      totalAmount: 241020,
      status: OrderLifecycleStatus.processing,
      paymentMethod: 'Prepaid - HDFC NetBanking (Insured)',
      paymentStatus: 'Paid',
      orderDate: DateTime.now().subtract(const Duration(hours: 4)),
      trackingNumber: 'ARMOR-LUX-89210',
    ),
    OrderModel(
      id: 'ord_1002',
      orderNumber: 'AURA-2026-9813',
      customerName: 'Vikramaditya Singhania',
      customerEmail: 'vikram.singhania@corp.com',
      customerPhone: '+91 99201 88472',
      shippingAddress: 'Penthouse 14B, Altamount Road, Mumbai, MH - 400026',
      items: const [
        OrderItemModel(
          productId: 'prod_3',
          productName: 'Padmavati Royal Solitaire Ring',
          imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=600&q=80',
          unitPrice: 92000,
          quantity: 1,
          size: '8',
          karat: '18K',
          grossWeightGrams: 6.8,
        ),
      ],
      subtotal: 92000,
      discountAmount: 0,
      taxAmount: 2760,
      totalAmount: 94760,
      status: OrderLifecycleStatus.shipped,
      paymentMethod: 'Prepaid - ICICI Diamond Card',
      paymentStatus: 'Paid',
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      trackingNumber: 'BLUEDART-SEC-44109',
    ),
    OrderModel(
      id: 'ord_1003',
      orderNumber: 'AURA-2026-9814',
      customerName: 'Sunita Rao',
      customerEmail: 'sunita.rao@gmail.com',
      customerPhone: '+91 98840 55123',
      shippingAddress: 'No. 42, Poes Garden, Chennai, TN - 600086',
      items: const [
        OrderItemModel(
          productId: 'prod_5',
          productName: 'Maharani Bridal Haar Set',
          imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=600&q=80',
          unitPrice: 345000,
          quantity: 1,
          size: 'Free Size',
          karat: '22K',
          grossWeightGrams: 92.0,
        ),
      ],
      subtotal: 345000,
      discountAmount: 25000,
      taxAmount: 9600,
      totalAmount: 329600,
      status: OrderLifecycleStatus.delivered,
      paymentMethod: 'Prepaid - Axis Bank UPI',
      paymentStatus: 'Paid',
      orderDate: DateTime.now().subtract(const Duration(days: 4)),
      deliveryDate: DateTime.now().subtract(const Duration(days: 1)),
      trackingNumber: 'ARMOR-LUX-77412',
    ),
    OrderModel(
      id: 'ord_1004',
      orderNumber: 'AURA-2026-9815',
      customerName: 'Ananya Sharma',
      customerEmail: 'ananya.sharma@outlook.com',
      customerPhone: '+91 97110 33491',
      shippingAddress: 'Sector 15, Golf Links, New Delhi, DL - 110003',
      items: const [
        OrderItemModel(
          productId: 'prod_4',
          productName: 'Kada Rajwada Antique Bangle',
          imageUrl: 'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=600&q=80',
          unitPrice: 142000,
          quantity: 1,
          size: '2.6',
          karat: '22K',
          grossWeightGrams: 36.4,
        ),
      ],
      subtotal: 142000,
      discountAmount: 0,
      taxAmount: 4260,
      totalAmount: 146260,
      status: OrderLifecycleStatus.rejected,
      paymentMethod: 'Cash on Secured Delivery',
      paymentStatus: 'Cancelled',
      orderDate: DateTime.now().subtract(const Duration(days: 3)),
      rejectionReason: 'Customer requested size modification before fabrication.',
    ),
    OrderModel(
      id: 'ord_1005',
      orderNumber: 'AURA-2026-9816',
      customerName: 'Priya Mukherjee',
      customerEmail: 'priya.mukh@gmail.com',
      customerPhone: '+91 98300 44219',
      shippingAddress: 'Ballygunge Circular Road, Kolkata, WB - 700019',
      items: const [
        OrderItemModel(
          productId: 'prod_2',
          productName: 'Mayur Jhumka Chandbali Earrings',
          imageUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=600&q=80',
          unitPrice: 64000,
          quantity: 1,
          size: 'Standard',
          karat: '22K',
          grossWeightGrams: 16.2,
        ),
      ],
      subtotal: 64000,
      discountAmount: 5000,
      taxAmount: 1770,
      totalAmount: 60770,
      status: OrderLifecycleStatus.pending,
      paymentMethod: 'Prepaid - PhonePe UPI',
      paymentStatus: 'Paid',
      orderDate: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
  ];

  GoldRateModel _mockGoldRates = GoldRateModel.defaultRates();

  // ===========================================================================
  // PRODUCTS / ITEMS
  // ===========================================================================

  @override
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final snapshot = await _firebaseService.firestore.collection('products').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return ProductModel.fromJson(data);
        }).toList();
      }
    } catch (e) {
      debugPrint("Firestore fetchProducts fallback: $e");
    }
    return List.from(_mockProducts);
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    try {
      final docRef = await _firebaseService.firestore.collection('products').add(product.toJson());
      final newProd = product.copyWith(id: docRef.id);
      _mockProducts.insert(0, newProd);
    } catch (e) {
      debugPrint("Firestore addProduct fallback: $e");
      final newProd = product.id.isEmpty
          ? product.copyWith(id: 'prod_${DateTime.now().millisecondsSinceEpoch}')
          : product;
      _mockProducts.insert(0, newProd);
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firebaseService.firestore.collection('products').doc(product.id).set(product.toJson());
      final idx = _mockProducts.indexWhere((p) => p.id == product.id);
      if (idx != -1) _mockProducts[idx] = product;
    } catch (e) {
      debugPrint("Firestore updateProduct fallback: $e");
      final idx = _mockProducts.indexWhere((p) => p.id == product.id);
      if (idx != -1) _mockProducts[idx] = product;
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await _firebaseService.firestore.collection('products').doc(productId).delete();
      _mockProducts.removeWhere((p) => p.id == productId);
    } catch (e) {
      debugPrint("Firestore deleteProduct fallback: $e");
      _mockProducts.removeWhere((p) => p.id == productId);
    }
  }

  // ===========================================================================
  // CATEGORIES
  // ===========================================================================

  @override
  Future<List<AdminCategoryModel>> fetchCategories() async {
    try {
      final snapshot = await _firebaseService.firestore.collection('categories').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return AdminCategoryModel.fromJson(data);
        }).toList();
      }
    } catch (e) {
      debugPrint("Firestore fetchCategories fallback: $e");
    }
    return List.from(_mockCategories);
  }

  @override
  Future<void> addCategory(AdminCategoryModel category) async {
    try {
      final docRef = await _firebaseService.firestore.collection('categories').add(category.toJson());
      final newCat = category.copyWith(id: docRef.id);
      _mockCategories.add(newCat);
    } catch (e) {
      debugPrint("Firestore addCategory fallback: $e");
      final newCat = category.id.isEmpty
          ? category.copyWith(id: 'cat_${DateTime.now().millisecondsSinceEpoch}')
          : category;
      _mockCategories.add(newCat);
    }
  }

  @override
  Future<void> updateCategory(AdminCategoryModel category) async {
    try {
      await _firebaseService.firestore.collection('categories').doc(category.id).set(category.toJson());
      final idx = _mockCategories.indexWhere((c) => c.id == category.id);
      if (idx != -1) _mockCategories[idx] = category;
    } catch (e) {
      debugPrint("Firestore updateCategory fallback: $e");
      final idx = _mockCategories.indexWhere((c) => c.id == category.id);
      if (idx != -1) _mockCategories[idx] = category;
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firebaseService.firestore.collection('categories').doc(categoryId).delete();
      _mockCategories.removeWhere((c) => c.id == categoryId);
    } catch (e) {
      debugPrint("Firestore deleteCategory fallback: $e");
      _mockCategories.removeWhere((c) => c.id == categoryId);
    }
  }

  // ===========================================================================
  // OFFERS & COUPONS
  // ===========================================================================

  @override
  Future<List<OfferModel>> fetchOffers() async {
    try {
      final snapshot = await _firebaseService.firestore.collection('offers').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return OfferModel.fromJson(data);
        }).toList();
      }
    } catch (e) {
      debugPrint("Firestore fetchOffers fallback: $e");
    }
    return List.from(_mockOffers);
  }

  @override
  Future<void> addOffer(OfferModel offer) async {
    try {
      final docRef = await _firebaseService.firestore.collection('offers').add(offer.toJson());
      _mockOffers.insert(0, offer.copyWith(id: docRef.id));
    } catch (e) {
      debugPrint("Firestore addOffer fallback: $e");
      final newOffer = offer.id.isEmpty
          ? offer.copyWith(id: 'off_${DateTime.now().millisecondsSinceEpoch}')
          : offer;
      _mockOffers.insert(0, newOffer);
    }
  }

  @override
  Future<void> updateOffer(OfferModel offer) async {
    try {
      await _firebaseService.firestore.collection('offers').doc(offer.id).set(offer.toJson());
      final idx = _mockOffers.indexWhere((o) => o.id == offer.id);
      if (idx != -1) _mockOffers[idx] = offer;
    } catch (e) {
      debugPrint("Firestore updateOffer fallback: $e");
      final idx = _mockOffers.indexWhere((o) => o.id == offer.id);
      if (idx != -1) _mockOffers[idx] = offer;
    }
  }

  @override
  Future<void> deleteOffer(String offerId) async {
    try {
      await _firebaseService.firestore.collection('offers').doc(offerId).delete();
      _mockOffers.removeWhere((o) => o.id == offerId);
    } catch (e) {
      debugPrint("Firestore deleteOffer fallback: $e");
      _mockOffers.removeWhere((o) => o.id == offerId);
    }
  }

  @override
  Future<void> toggleOfferStatus(String offerId, bool isActive) async {
    final idx = _mockOffers.indexWhere((o) => o.id == offerId);
    if (idx != -1) {
      final updated = _mockOffers[idx].copyWith(isActive: isActive);
      await updateOffer(updated);
    }
  }

  // ===========================================================================
  // COMBOS & BRIDAL SETS
  // ===========================================================================

  @override
  Future<List<ComboModel>> fetchCombos() async {
    try {
      final snapshot = await _firebaseService.firestore.collection('combos').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return ComboModel.fromJson(data);
        }).toList();
      }
    } catch (e) {
      debugPrint("Firestore fetchCombos fallback: $e");
    }
    return List.from(_mockCombos);
  }

  @override
  Future<void> addCombo(ComboModel combo) async {
    try {
      final docRef = await _firebaseService.firestore.collection('combos').add(combo.toJson());
      _mockCombos.insert(0, combo.copyWith(id: docRef.id));
    } catch (e) {
      debugPrint("Firestore addCombo fallback: $e");
      final newCombo = combo.id.isEmpty
          ? combo.copyWith(id: 'combo_${DateTime.now().millisecondsSinceEpoch}')
          : combo;
      _mockCombos.insert(0, newCombo);
    }
  }

  @override
  Future<void> updateCombo(ComboModel combo) async {
    try {
      await _firebaseService.firestore.collection('combos').doc(combo.id).set(combo.toJson());
      final idx = _mockCombos.indexWhere((c) => c.id == combo.id);
      if (idx != -1) _mockCombos[idx] = combo;
    } catch (e) {
      debugPrint("Firestore updateCombo fallback: $e");
      final idx = _mockCombos.indexWhere((c) => c.id == combo.id);
      if (idx != -1) _mockCombos[idx] = combo;
    }
  }

  @override
  Future<void> deleteCombo(String comboId) async {
    try {
      await _firebaseService.firestore.collection('combos').doc(comboId).delete();
      _mockCombos.removeWhere((c) => c.id == comboId);
    } catch (e) {
      debugPrint("Firestore deleteCombo fallback: $e");
      _mockCombos.removeWhere((c) => c.id == comboId);
    }
  }

  // ===========================================================================
  // ORDERS LIFECYCLE
  // ===========================================================================

  @override
  Future<List<OrderModel>> fetchOrders() async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return OrderModel.fromJson(data);
        }).toList();
      }
    } catch (e) {
      debugPrint("Firestore fetchOrders fallback: $e");
    }
    return List.from(_mockOrders);
  }

  @override
  Future<void> updateOrderStatus(
    String orderId,
    OrderLifecycleStatus newStatus, {
    String? rejectionReason,
  }) async {
    try {
      await _firebaseService.firestore.collection('orders').doc(orderId).update({
        'status': newStatus.name,
        if (rejectionReason != null) 'rejectionReason': rejectionReason,
        if (newStatus == OrderLifecycleStatus.delivered)
          'deliveryDate': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("Firestore updateOrderStatus fallback: $e");
    }

    final idx = _mockOrders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      _mockOrders[idx] = _mockOrders[idx].copyWith(
        status: newStatus,
        rejectionReason: rejectionReason ?? _mockOrders[idx].rejectionReason,
        deliveryDate: newStatus == OrderLifecycleStatus.delivered
            ? DateTime.now()
            : _mockOrders[idx].deliveryDate,
      );
    }
  }

  @override
  Future<void> addOrder(OrderModel order) async {
    try {
      final docRef = await _firebaseService.firestore.collection('orders').add(order.toJson());
      _mockOrders.insert(0, order.copyWith(id: docRef.id));
    } catch (e) {
      debugPrint("Firestore addOrder fallback: $e");
      final newOrd = order.id.isEmpty
          ? order.copyWith(id: 'ord_${DateTime.now().millisecondsSinceEpoch}')
          : order;
      _mockOrders.insert(0, newOrd);
    }
  }

  // ===========================================================================
  // DAILY PRECIOUS METAL RATES
  // ===========================================================================

  @override
  Future<GoldRateModel> fetchGoldRates() async {
    try {
      final doc = await _firebaseService.firestore.collection('settings').doc('gold_rates').get();
      if (doc.exists && doc.data() != null) {
        return GoldRateModel.fromJson(doc.data()!);
      }
    } catch (e) {
      debugPrint("Firestore fetchGoldRates fallback: $e");
    }
    return _mockGoldRates;
  }

  @override
  Future<void> updateGoldRates(GoldRateModel rates) async {
    try {
      await _firebaseService.firestore
          .collection('settings')
          .doc('gold_rates')
          .set(rates.toJson());
    } catch (e) {
      debugPrint("Firestore updateGoldRates fallback: $e");
    }
    _mockGoldRates = rates;
  }

  // ===========================================================================
  // BUSINESS ANALYTICS & INSIGHTS
  // ===========================================================================

  @override
  Future<AdminAnalyticsModel> fetchAnalytics() async {
    final products = await fetchProducts();
    final categories = await fetchCategories();
    final offers = await fetchOffers();
    final combos = await fetchCombos();
    final orders = await fetchOrders();

    double revenue = 0.0;
    int activeCount = 0;
    int completedCount = 0;
    int rejectedCount = 0;

    for (final o in orders) {
      if (o.status.isCompleted || o.status.isActive) {
        revenue += o.totalAmount;
      }
      if (o.status.isActive) activeCount++;
      if (o.status.isCompleted) completedCount++;
      if (o.status.isRejected) rejectedCount++;
    }

    final double aov = orders.isNotEmpty ? (revenue / orders.length) : 0.0;

    // Low stock items (< 5 units)
    final lowStock = products.where((p) => p.stockCount <= 5).toList();

    // Category distribution counts
    final Map<String, int> catDist = {};
    for (final p in products) {
      catDist[p.categoryId] = (catDist[p.categoryId] ?? 0) + 1;
    }

    // Monthly sample revenue trend
    final List<MonthlySalesPoint> monthlyPoints = [
      MonthlySalesPoint(month: 'May', revenue: revenue * 0.18, orderCount: 22),
      MonthlySalesPoint(month: 'Jun', revenue: revenue * 0.22, orderCount: 31),
      MonthlySalesPoint(month: 'Jul', revenue: revenue * 0.28, orderCount: 42),
      MonthlySalesPoint(month: 'Aug', revenue: revenue * 0.32, orderCount: 56),
    ];

    return AdminAnalyticsModel(
      totalRevenue: revenue,
      totalOrders: orders.length,
      activeOrdersCount: activeCount,
      completedOrdersCount: completedCount,
      rejectedOrdersCount: rejectedCount,
      averageOrderValue: aov,
      totalProducts: products.length,
      totalCategories: categories.length,
      activeOffersCount: offers.where((o) => o.isActive).length,
      activeCombosCount: combos.where((c) => c.inStock).length,
      lowStockProducts: lowStock,
      categoryDistribution: catDist,
      monthlyRevenue: monthlyPoints,
    );
  }
}
