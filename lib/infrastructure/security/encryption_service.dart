import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Service for encrypting and decrypting sensitive data before storage.
class EncryptionService {
  final FlutterSecureStorage _storage;
  static const String _keyName = 'db_encryption_key';

  EncryptionService(this._storage);

  /// Get or create a 256-bit key for encryption.
  Future<String> _getOrCreateKey() async {
    String? key = await _storage.read(key: _keyName);
    if (key == null) {
      // In a real app, generate a truly random key.
      // For this skeleton, we use a placeholder derivation.
      key = base64Url.encode(sha256.convert(utf8.encode(DateTime.now().toIso8601String())).bytes);
      await _storage.write(key: _keyName, value: key);
    }
    return key;
  }

  /// Encrypt a plaintext string.
  ///
  /// IMPORTANT: This is a placeholder XOR implementation for the skeleton.
  /// In a production environment, use a robust library like 'encrypt'
  /// with AES-GCM and a properly generated random key.
  Future<String> encrypt(String plaintext) async {
    final key = await _getOrCreateKey();
    // Simplified: Just xor or use a library.
    // In production, use a package like 'encrypt' with AES-GCM.
    final bytes = utf8.encode(plaintext);
    final keyBytes = utf8.encode(key);
    final encrypted = List<int>.generate(bytes.length, (i) => bytes[i] ^ keyBytes[i % keyBytes.length]);
    return base64Url.encode(encrypted);
  }

  /// Decrypt an encrypted string.
  Future<String> decrypt(String encryptedBase64) async {
    final key = await _getOrCreateKey();
    final bytes = base64Url.decode(encryptedBase64);
    final keyBytes = utf8.encode(key);
    final decrypted = List<int>.generate(bytes.length, (i) => bytes[i] ^ keyBytes[i % keyBytes.length]);
    return utf8.decode(decrypted);
  }
}
