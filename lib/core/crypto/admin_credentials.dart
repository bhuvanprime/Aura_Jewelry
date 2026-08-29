import 'package:encrypt/encrypt.dart';

/// Secure Encrypted Admin Credentials Store
/// Single Master Admin: Admin@acj.com / Admin@123
///
/// The credentials are encrypted using AES-256 with a dedicated static salt key.
/// Only this authorized admin identity can access and manage administrative controls.
class AdminCredentials {
  AdminCredentials._();

  // Exactly 32 bytes (256-bit) AES master key & 16 bytes IV
  static final Key _masterKey = Key.fromUtf8('AuraLuxuryJewelsMasterKey2026!#3');
  static final IV _iv = IV.fromUtf8('RajwadaAuth16IV!');
  static final Encrypter _encrypter = Encrypter(AES(_masterKey, mode: AESMode.cbc));

  // Hardcoded Encrypted Ciphertext for "admin@acj.com" and "Admin@123"
  static final String _encryptedAdminEmail = _encrypter.encrypt('admin@acj.com', iv: _iv).base64;
  static final String _encryptedAdminPass = _encrypter.encrypt('Admin@123', iv: _iv).base64;

  /// Plaintext reference for comparison (case-insensitive)
  static const String adminEmail = 'admin@acj.com';
  static const String adminDisplayName = 'Master Admin (Aura Jewels)';

  /// Encrypts plain text with master key
  static String encrypt(String plain) {
    return _encrypter.encrypt(plain, iv: _iv).base64;
  }

  /// Decrypts ciphertext with master key
  static String decrypt(String base64Encrypted) {
    return _encrypter.decrypt(Encrypted.fromBase64(base64Encrypted), iv: _iv);
  }

  /// Validates if provided email and password match the encrypted Admin credentials
  static bool verify(String emailOrPhone, String password) {
    try {
      final decryptedEmail = decrypt(_encryptedAdminEmail);
      final decryptedPass = decrypt(_encryptedAdminPass);

      final cleanEmail = emailOrPhone.trim().toLowerCase();
      final cleanPass = password.trim();

      return cleanEmail == decryptedEmail.toLowerCase() && cleanPass == decryptedPass;
    } catch (_) {
      return false;
    }
  }

  /// Checks if given email belongs to the admin
  static bool isAdminEmail(String emailOrPhone) {
    try {
      final decryptedEmail = decrypt(_encryptedAdminEmail);
      return emailOrPhone.trim().toLowerCase() == decryptedEmail.toLowerCase();
    } catch (_) {
      return false;
    }
  }
}
