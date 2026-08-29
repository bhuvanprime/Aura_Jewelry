import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../firebase_options.dart';

/// Centralized Firebase service managing Cloud Firestore, Firebase Storage (Free Bucket),
/// and Firebase Authentication for the AuraJewelry project.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        _isInitialized = true;
        debugPrint("Firebase successfully initialized for AuraJewelry project.");
      } catch (e) {
        debugPrint("Firebase initialize with options fallback: $e");
        try {
          await Firebase.initializeApp();
          _isInitialized = true;
        } catch (_) {}
      }
    }
  }

  bool get isInitialized => _isInitialized;

  // Cloud Firestore database
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  // Firebase Authentication
  FirebaseAuth get auth => FirebaseAuth.instance;

  // Firebase Cloud Storage (Free tier bucket)
  FirebaseStorage get storage => FirebaseStorage.instance;

  // Real-time snapshot listener wrapper
  Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream(String collectionPath, String documentId) {
    return firestore.collection(collectionPath).doc(documentId).snapshots();
  }
}
