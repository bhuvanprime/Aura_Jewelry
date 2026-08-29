import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  UserModel? _currentUser;

  @override
  Future<void> initiateLogin(String emailOrPhone) async {
    // 1. Dispatch OTP via Mock Service
  }

  @override
  Future<UserModel> verifyOtp(String emailOrPhone, String otp) async {
    try {
      // 3. Check if user exists in Firestore
      final querySnapshot = await _firebaseService.firestore
          .collection('users')
          .where('emailOrPhone', isEqualTo: emailOrPhone)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User exists
        final doc = querySnapshot.docs.first;
        _currentUser = UserModel(
          uid: doc.id,
          emailOrPhone: emailOrPhone, // Keep plain in memory
          role: doc['role'] as String,
        );
      } else {
        // Create new user
        final newUserRef = _firebaseService.firestore.collection('users').doc();
        await newUserRef.set({
          'uid': newUserRef.id,
          'emailOrPhone': emailOrPhone,
          'role': 'customer',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });

        _currentUser = UserModel(
          uid: newUserRef.id,
          emailOrPhone: emailOrPhone,
          role: 'customer',
        );
      }
      return _currentUser!;
    } catch (e) {
      // Fallback for when Firebase isn't fully configured yet (development mode)
      debugPrint("Firebase error (expected if not configured): $e");
      _currentUser = UserModel(
        uid: 'mock_uid_${DateTime.now().millisecondsSinceEpoch}',
        emailOrPhone: emailOrPhone,
        role: 'customer',
      );
      return _currentUser!;
    }
  }

  @override
  Future<UserModel> continueAsGuest() async {
    _currentUser = UserModel.guest();
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }
}
