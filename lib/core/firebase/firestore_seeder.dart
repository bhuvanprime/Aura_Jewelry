import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';
import '../../features/products/domain/models/product_model.dart';
import '../../features/admin/domain/models/admin_category_model.dart';
import '../../features/admin/domain/models/offer_model.dart';
import '../../features/admin/domain/models/gold_rate_model.dart';

/// Ensures Cloud Firestore in project `aurajewelry-2d68d` is populated with initial
/// live collections (products, categories, offers, combos, gold_rates) if empty.
class FirestoreSeeder {
  static Future<void> seedInitialDataIfEmpty() async {
    try {
      final firestore = FirebaseService.instance.firestore;
      
      // 1. Seed Products if empty
      final prodSnap = await firestore.collection('products').limit(1).get().timeout(const Duration(seconds: 2));
      if (prodSnap.docs.isEmpty) {
        debugPrint("Seeding initial products to Cloud Firestore...");
        final initialProducts = [
          const ProductModel(
            id: 'prod_1',
            name: 'Nizam Heritage Polki Necklace',
            price: 185000,
            rating: 4.9,
            imageUrl: 'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=600&q=80',
            images: [
              'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=600&q=80',
              'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=600&q=80',
              'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=600&q=80',
            ],
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
            images: [
              'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=600&q=80',
              'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=600&q=80',
            ],
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
            images: [
              'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=600&q=80',
              'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?auto=format&fit=crop&w=600&q=80',
            ],
            description: '18K hallmarked yellow gold ring featuring a certified 1.2 carat brilliant cut VVS1 solitaire.',
            availableSizes: ['6', '7', '8', '9', '10'],
            categoryId: 'ring',
            karat: '18K',
            grossWeightGrams: 6.8,
            makingChargesPercent: 8.0,
            stockCount: 4,
          ),
          const ProductModel(
            id: 'prod_4',
            name: 'Kada Rajwada Antique Bangle',
            price: 142000,
            rating: 4.7,
            imageUrl: 'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=600&q=80',
            images: [
              'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=600&q=80',
              'https://images.unsplash.com/photo-1573408301145-b98c4af3066b?auto=format&fit=crop&w=600&q=80',
            ],
            description: 'Heavy 22K temple-engraved gold kada with screw lock mechanism and floral filigree.',
            availableSizes: ['2.4', '2.6', '2.8'],
            categoryId: 'bangle',
            karat: '22K',
            grossWeightGrams: 36.4,
            makingChargesPercent: 11.0,
            stockCount: 3,
          ),
          const ProductModel(
            id: 'prod_5',
            name: 'Maharani Bridal Haar Set',
            price: 345000,
            rating: 5.0,
            imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=600&q=80',
            images: [
              'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=600&q=80',
              'https://images.unsplash.com/photo-1599643478524-fb66f7ca066d?auto=format&fit=crop&w=600&q=80',
            ],
            description: 'Opulent multi-layered kundan bridal set with matching earrings and maang tikka.',
            availableSizes: ['Free Size'],
            categoryId: 'bridal',
            karat: '22K',
            grossWeightGrams: 92.0,
            makingChargesPercent: 14.0,
            stockCount: 5,
          ),
        ];

        for (final p in initialProducts) {
          await firestore.collection('products').doc(p.id).set(p.toJson(), SetOptions(merge: true));
        }
      }

      // 2. Seed Categories if empty
      final catSnap = await firestore.collection('categories').limit(1).get().timeout(const Duration(seconds: 2));
      if (catSnap.docs.isEmpty) {
        debugPrint("Seeding initial categories to Cloud Firestore...");
        final initialCategories = [
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
          ),
          const AdminCategoryModel(
            id: 'earring',
            name: 'Earrings & Jhumkas',
            iconUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=300&q=80',
            bannerUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=800&q=80',
            segment: 'Women',
            styles: [
              AdminCategoryStyle(id: 's4', name: 'Chandbali Jhumkas', imageUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=200&q=80'),
              AdminCategoryStyle(id: 's5', name: 'Solitaire Studs', imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=200&q=80'),
            ],
          ),
          const AdminCategoryModel(
            id: 'ring',
            name: 'Rings & Solitaires',
            iconUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=300&q=80',
            bannerUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=800&q=80',
            segment: 'Unisex',
            styles: [
              AdminCategoryStyle(id: 's6', name: 'Engagement Bands', imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b2548e?auto=format&fit=crop&w=200&q=80'),
            ],
          ),
          const AdminCategoryModel(
            id: 'bangle',
            name: 'Bangles & Kadas',
            iconUrl: 'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=300&q=80',
            bannerUrl: 'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=800&q=80',
            segment: 'Women',
            styles: [
              AdminCategoryStyle(id: 's7', name: 'Rajwada Antique Kada', imageUrl: 'https://images.unsplash.com/photo-1611591475155-42e9fba5ce55?auto=format&fit=crop&w=200&q=80'),
            ],
          ),
          const AdminCategoryModel(
            id: 'bridal',
            name: 'Bridal Heritage Sets',
            iconUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=300&q=80',
            bannerUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=800&q=80',
            segment: 'Bridal',
            styles: [
              AdminCategoryStyle(id: 's8', name: 'Maharani Complete Set', imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?auto=format&fit=crop&w=200&q=80'),
            ],
          ),
        ];

        for (final c in initialCategories) {
          await firestore.collection('categories').doc(c.id).set(c.toJson(), SetOptions(merge: true));
        }
      }

      // 3. Seed Offers & Combos if empty
      final offSnap = await firestore.collection('offers').limit(1).get().timeout(const Duration(seconds: 2));
      if (offSnap.docs.isEmpty) {
        const initialOffer = OfferModel(
          id: 'off_festive_2026',
          title: 'Royal Rajwada Festive Discount',
          code: 'ROYAL2026',
          discountType: 'percentage',
          discountValue: 15.0,
          maxDiscount: 25000.0,
          minOrderValue: 50000.0,
          validTill: '2026-12-31',
          description: 'Get flat 15% off up to ₹25,000 on handcrafted gold & diamond heritage jewelry.',
          isActive: true,
        );
        await firestore.collection('offers').doc(initialOffer.id).set(initialOffer.toJson(), SetOptions(merge: true));
      }

      // 4. Seed Gold Rates if empty
      final rateSnap = await firestore.collection('settings').doc('gold_rates').get().timeout(const Duration(seconds: 2));
      if (!rateSnap.exists) {
        await firestore.collection('settings').doc('gold_rates').set(GoldRateModel.defaultRates().toJson(), SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("Firestore initial seed notice (offline/fallback safe): $e");
    }
  }
}
