import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';

/// A service to handle symmetric encryption for sensitive PII data before saving to Firestore.
class EncryptionService {
  EncryptionService._();
  static final EncryptionService instance = EncryptionService._();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _encryptionKeyAlias = 'aura_encryption_key';
  
  late Key _key;
  late IV _iv;
  late Encrypter _encrypter;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Check if we already have a generated 32-byte key in secure storage
    String? storedKey = await _secureStorage.read(key: _encryptionKeyAlias);
    
    if (storedKey == null) {
      // 2. If not, generate a secure random 32-byte key (256-bit AES)
      final random = Random.secure();
      final values = List<int>.generate(32, (i) => random.nextInt(256));
      storedKey = base64UrlEncode(values);
      await _secureStorage.write(key: _encryptionKeyAlias, value: storedKey);
    }

    // 3. Initialize the Encrypter
    _key = Key.fromBase64(storedKey);
    _iv = IV.fromLength(16); // Standard 16-byte initialization vector for AES
    _encrypter = Encrypter(AES(_key));
    
    _isInitialized = true;
  }

  /// Encrypts plain text (e.g., an email or phone number).
  String encryptData(String plainText) {
    if (!_isInitialized) throw Exception('EncryptionService not initialized');
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypts encrypted text back to plain text.
  String decryptData(String encryptedBase64) {
    if (!_isInitialized) throw Exception('EncryptionService not initialized');
    final encrypted = Encrypted.fromBase64(encryptedBase64);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}
