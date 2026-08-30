import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';

/// 100% Cloud Firestore Real-Time Product Repository (Zero Hardcoded Data)
class ProductRepositoryImpl implements ProductRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  @override
  Stream<List<ProductModel>> watchProducts() {
    return _firebaseService.firestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return ProductModel.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<void> toggleWishlist(String productId, bool newStatus) async {
    try {
      await _firebaseService.firestore
          .collection('products')
          .doc(productId)
          .update({'isWishlisted': newStatus})
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      debugPrint("Wishlist toggle notice: $e");
    }
  }
}
