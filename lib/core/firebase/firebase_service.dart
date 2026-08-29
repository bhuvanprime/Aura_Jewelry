import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A centralized service class to handle all raw Firebase operations,
/// ensuring that UI and Repository layers don't interact with Firebase directly.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await Firebase.initializeApp();
      _isInitialized = true;
    }
  }

  // Generic getter for Firestore
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  // Generic getter for Auth
  FirebaseAuth get auth => FirebaseAuth.instance;

  // Real-time sync example wrapper (Snapshot Listeners)
  Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream(String collectionPath, String documentId) {
    return firestore.collection(collectionPath).doc(documentId).snapshots();
  }
}
