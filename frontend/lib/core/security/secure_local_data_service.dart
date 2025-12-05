import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'encryption_service.dart';
import '../../utils/logger.dart';

/// Secure wrapper around LocalJsonService with encryption and validation
class SecureLocalDataService {
  static final SecureLocalDataService _instance = SecureLocalDataService._internal();
  factory SecureLocalDataService() => _instance;
  SecureLocalDataService._internal();

  final EncryptionService _encryption = EncryptionService();
  Directory? _dataDirectory;
  final Map<String, List<dynamic>> _cache = {};
  final Map<String, String> _checksums = {};

  Future<Directory?> _getDataDirectory() async {
    // path_provider doesn't work on web
    if (kIsWeb) return null;
    
    if (_dataDirectory != null) return _dataDirectory;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      _dataDirectory = Directory('${appDir.path}/data');
      if (!await _dataDirectory!.exists()) {
        await _dataDirectory!.create(recursive: true);
      }
      return _dataDirectory;
    } catch (e) {
      AppLogger.warning('Failed to get data directory (web platform?): $e');
      return null;
    }
  }

  Future<String> _getAssetPath(String filename) async {
    return 'assets/data/$filename';
  }

  Future<String?> _getLocalPath(String filename) async {
    final dataDir = await _getDataDirectory();
    if (dataDir == null) return null;
    return '${dataDir.path}/$filename.enc';
  }

  Future<String?> _getSecurePath(String filename) async {
    final dataDir = await _getDataDirectory();
    if (dataDir == null) return null;
    return '${dataDir.path}/$filename.enc';
  }

  /// Initialize the service
  Future<void> initialize() async {
    await _encryption.initialize();
    AppLogger.info('SecureLocalDataService initialized');
  }

  /// Load JSON with decryption and validation
  Future<List<dynamic>> loadJson(String filename) async {
    try {
      // Check cache first
      if (_cache.containsKey(filename)) {
        return _cache[filename]!;
      }

      // On web, only load from assets
      if (kIsWeb) {
        return await _loadFromAssetOrUnencrypted(filename);
      }

      final securePath = await _getSecurePath(filename);
      if (securePath == null) {
        // Fallback to asset on web
        return await _loadFromAssetOrUnencrypted(filename);
      }
      
      final secureFile = File(securePath);
      List<dynamic> data;
      
      if (await secureFile.exists()) {
        // Load encrypted file
        final encryptedContent = await secureFile.readAsString();
        final decryptedContent = _encryption.decryptString(encryptedContent);
        
        // Verify checksum if available
        final checksumPath = '$securePath.checksum';
        if (await File(checksumPath).exists()) {
          final expectedChecksum = await File(checksumPath).readAsString();
          if (!_encryption.verifyChecksum(decryptedContent, expectedChecksum)) {
            AppLogger.warning('Checksum verification failed for $filename, using fallback');
            // Try to load from unencrypted backup or asset
            return await _loadFromAssetOrUnencrypted(filename);
          }
        }
        
        data = json.decode(decryptedContent) as List<dynamic>;
      } else {
        // Try to load from unencrypted file or asset
        data = await _loadFromAssetOrUnencrypted(filename);
        // Encrypt and save for future use (only on non-web platforms)
        if (!kIsWeb) {
          await saveJson(filename, data);
        }
      }

      // Cache the data
      _cache[filename] = data;
      return data;
    } catch (e) {
      AppLogger.error('Failed to load $filename: $e');
      return [];
    }
  }

  Future<List<dynamic>> _loadFromAssetOrUnencrypted(String filename) async {
    // On web, skip file system access
    if (!kIsWeb) {
      // Try unencrypted local file first
      final localPath = await _getLocalPath(filename);
      if (localPath != null) {
        final localFile = File(localPath);
        if (await localFile.exists()) {
          final content = await localFile.readAsString();
          return json.decode(content) as List<dynamic>;
        }
      }
    }
    
    // Fallback to asset
    final assetPath = await _getAssetPath(filename);
    try {
      final content = await rootBundle.loadString(assetPath);
      final data = json.decode(content) as List<dynamic>;
      return data;
    } catch (e) {
      AppLogger.warning('Failed to load asset $assetPath: $e');
      return [];
    }
  }

  /// Save JSON with encryption and checksum
  Future<void> saveJson(String filename, List<dynamic> data) async {
    try {
      // Validate data
      _validateData(data);

      // On web, only update cache (file system not available)
      if (kIsWeb) {
        _cache[filename] = data;
        final jsonString = json.encode(data);
        _checksums[filename] = _encryption.generateChecksum(jsonString);
        AppLogger.info('Updated cache for $filename (web platform - no file save)');
        return;
      }

      final jsonString = json.encode(data);
      final encryptedContent = _encryption.encryptString(jsonString);
      final checksum = _encryption.generateChecksum(jsonString);

      final securePath = await _getSecurePath(filename);
      if (securePath == null) {
        // Fallback: just update cache
        _cache[filename] = data;
        _checksums[filename] = checksum;
        return;
      }
      
      final secureFile = File(securePath);
      await secureFile.writeAsString(encryptedContent);

      // Save checksum
      final checksumPath = '$securePath.checksum';
      await File(checksumPath).writeAsString(checksum);

      // Update cache
      _cache[filename] = data;
      _checksums[filename] = checksum;

      AppLogger.info('Saved encrypted JSON: $filename');
    } catch (e) {
      AppLogger.error('Failed to save $filename: $e');
      // On web, don't throw - just log the error
      if (!kIsWeb) {
        throw Exception('Failed to save $filename: $e');
      }
    }
  }

  /// Validate data structure
  void _validateData(List<dynamic> data) {
    if (data.isEmpty) return;

    // Ensure all items are maps
    for (var item in data) {
      if (item is! Map<String, dynamic>) {
        throw FormatException('Invalid data format: expected Map, got ${item.runtimeType}');
      }

      // Ensure all items have an id
      if (!item.containsKey('id') || item['id'] == null) {
        throw FormatException('Invalid data: missing required field "id"');
      }
    }
  }

  /// Create entity with validation
  Future<Map<String, dynamic>> createEntity(String filename, Map<String, dynamic> entity) async {
    _validateEntity(entity);
    
    final data = await loadJson(filename);
    int newId = 1;
    if (data.isNotEmpty) {
      final maxId = data.map((e) => e['id'] as int? ?? 0).reduce((a, b) => a > b ? a : b);
      newId = maxId + 1;
    }
    entity['id'] = newId;
    data.add(entity);
    await saveJson(filename, data);
    return entity;
  }

  /// Get entity by ID
  Future<Map<String, dynamic>?> getEntity(String filename, int id) async {
    final data = await loadJson(filename);
    try {
      return data.firstWhere((e) => e['id'] == id) as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  /// Get all entities
  Future<List<dynamic>> getAllEntities(String filename) async {
    return await loadJson(filename);
  }

  /// Update entity with validation
  Future<Map<String, dynamic>?> updateEntity(String filename, int id, Map<String, dynamic> updatedEntity) async {
    _validateEntity(updatedEntity);
    
    final data = await loadJson(filename);
    final index = data.indexWhere((e) => e['id'] == id);
    if (index == -1) return null;
    updatedEntity['id'] = id;
    data[index] = updatedEntity;
    await saveJson(filename, data);
    return updatedEntity as Map<String, dynamic>?;
  }

  /// Delete entity
  Future<bool> deleteEntity(String filename, int id) async {
    final data = await loadJson(filename);
    final index = data.indexWhere((e) => e['id'] == id);
    if (index == -1) return false;
    data.removeAt(index);
    await saveJson(filename, data);
    return true;
  }

  /// Validate entity structure
  void _validateEntity(Map<String, dynamic> entity) {
    // Sanitize string fields
    entity.forEach((key, value) {
      if (value is String) {
        // Remove potentially dangerous characters
        entity[key] = value.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
      }
    });
  }

  /// Clear cache
  void clearCache() {
    _cache.clear();
    _checksums.clear();
  }

  /// Get data directory path (for internal use only)
  Future<String?> getDataDirectoryPath() async {
    final dir = await _getDataDirectory();
    return dir?.path;
  }
}


