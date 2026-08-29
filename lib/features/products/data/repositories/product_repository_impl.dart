import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final _controller = StreamController<List<ProductModel>>.broadcast();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _firestoreSubscription;
  
  final List<ProductModel> _mockProducts = [
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

  ProductRepositoryImpl() {
    _initFirestoreListener();
  }

  void _initFirestoreListener() {
    try {
      _firestoreSubscription = _firebaseService.firestore
          .collection('products')
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final liveProducts = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return ProductModel.fromJson(data);
          }).toList();
          _controller.add(liveProducts);
        } else {
          _controller.add(_mockProducts);
        }
      }, onError: (e) {
        debugPrint("Firestore products stream notice: $e");
        _controller.add(_mockProducts);
      });
    } catch (e) {
      debugPrint("Firestore listener init note: $e");
      _controller.add(_mockProducts);
    }
  }

  @override
  Stream<List<ProductModel>> watchProducts() {
    // Initial emit
    Future.microtask(() => _controller.add(_mockProducts));
    return _controller.stream;
  }

  @override
  Future<void> toggleWishlist(String productId, bool newStatus) async {
    try {
      await _firebaseService.firestore
          .collection('products')
          .doc(productId)
          .update({'isWishlisted': newStatus})
          .timeout(const Duration(milliseconds: 800));
    } catch (e) {
      debugPrint("Wishlist toggle local fallback: $e");
    }

    final index = _mockProducts.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final product = _mockProducts[index];
      _mockProducts[index] = product.copyWith(isWishlisted: newStatus);
      _controller.add(List.from(_mockProducts));
    }
  }
  
  void dispose() {
    _firestoreSubscription?.cancel();
    _controller.close();
  }
}
