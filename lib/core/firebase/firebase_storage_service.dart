import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_service.dart';

/// Service to upload and manage jewelry images and files in Firebase Storage
class FirebaseStorageService {
  FirebaseStorageService._();
  static final FirebaseStorageService instance = FirebaseStorageService._();

  FirebaseStorage get _storage => FirebaseService.instance.storage;

  /// Uploads image bytes to Firebase Storage under a designated folder
  /// (e.g. 'products', 'categories', 'combos', 'banners')
  Future<String?> uploadImageBytes({
    required Uint8List bytes,
    required String folder,
    required String fileName,
    String contentType = 'image/jpeg',
  }) async {
    try {
      final ref = _storage.ref().child('$folder/$fileName');
      final metadata = SettableMetadata(
        contentType: contentType,
        customMetadata: {'uploaded_by': 'AuraAdmin', 'timestamp': DateTime.now().toIso8601String()},
      );

      final uploadTask = await ref.putData(bytes, metadata);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint("FirebaseStorage upload error: $e");
      return null;
    }
  }

  /// Deletes a file from Firebase Storage by download URL
  Future<bool> deleteImageByUrl(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      return true;
    } catch (e) {
      debugPrint("FirebaseStorage delete error: $e");
      return false;
    }
  }
}
