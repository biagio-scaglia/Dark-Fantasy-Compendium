import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

/// Service for encrypting and decrypting data using AES-256
/// Uses device-specific key derived from secure storage
class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  static const String _keyStorageKey = '_encryption_key';
  static const String _ivStorageKey = '_encryption_iv';
  encrypt.Encrypter? _encrypter;
  encrypt.IV? _iv;
  bool _initialized = false;

  /// Initialize encryption service with device-specific key
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get or create encryption key
      String? keyString = prefs.getString(_keyStorageKey);
      if (keyString == null) {
        // Generate new key
        final key = encrypt.Key.fromSecureRandom(32);
        keyString = key.base64;
        await prefs.setString(_keyStorageKey, keyString);
      }

      // Get or create IV
      String? ivString = prefs.getString(_ivStorageKey);
      if (ivString == null) {
        // Generate new IV
        final iv = encrypt.IV.fromSecureRandom(16);
        ivString = iv.base64;
        await prefs.setString(_ivStorageKey, ivString);
      }

      final key = encrypt.Key.fromBase64(keyString);
      _iv = encrypt.IV.fromBase64(ivString);
      _encrypter = encrypt.Encrypter(encrypt.AES(key));

      _initialized = true;
    } catch (e) {
      throw Exception('Failed to initialize encryption: $e');
    }
  }

  /// Encrypt a string
  String encryptString(String plainText) {
    if (!_initialized || _encrypter == null || _iv == null) {
      throw Exception('Encryption service not initialized');
    }
    try {
      final encrypted = _encrypter!.encrypt(plainText, iv: _iv!);
      return encrypted.base64;
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  /// Decrypt a string
  String decryptString(String encryptedText) {
    if (!_initialized || _encrypter == null || _iv == null) {
      throw Exception('Encryption service not initialized');
    }
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      return _encrypter!.decrypt(encrypted, iv: _iv!);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  /// Encrypt JSON data
  String encryptJson(Map<String, dynamic> jsonData) {
    final jsonString = json.encode(jsonData);
    return encryptString(jsonString);
  }

  /// Decrypt JSON data
  Map<String, dynamic> decryptJson(String encryptedData) {
    final jsonString = decryptString(encryptedData);
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  /// Generate checksum for data integrity
  String generateChecksum(String data) {
    final bytes = utf8.encode(data);
    final digest = crypto.sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify checksum
  bool verifyChecksum(String data, String expectedChecksum) {
    final calculated = generateChecksum(data);
    return calculated == expectedChecksum;
  }
}


