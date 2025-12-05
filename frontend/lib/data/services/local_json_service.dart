import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/security/secure_local_data_service.dart';

/// Wrapper around SecureLocalDataService for backward compatibility
/// All data is now encrypted and validated
class LocalJsonService {
  static final LocalJsonService _instance = LocalJsonService._internal();
  factory LocalJsonService() => _instance;
  LocalJsonService._internal();

  final SecureLocalDataService _secureService = SecureLocalDataService();
  Directory? _dataDirectory;

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
      return null;
    }
  }

  /// Load JSON using secure service (encrypted)
  Future<List<dynamic>> loadJson(String filename) async {
    return await _secureService.loadJson(filename);
  }

  /// Save JSON using secure service (encrypted)
  Future<void> saveJson(String filename, List<dynamic> data) async {
    await _secureService.saveJson(filename, data);
  }

  /// Create entity using secure service
  Future<Map<String, dynamic>> createEntity(String filename, Map<String, dynamic> entity) async {
    return await _secureService.createEntity(filename, entity);
  }

  /// Get entity by ID using secure service
  Future<Map<String, dynamic>?> getEntity(String filename, int id) async {
    return await _secureService.getEntity(filename, id);
  }

  /// Get all entities using secure service
  Future<List<dynamic>> getAllEntities(String filename) async {
    return await _secureService.getAllEntities(filename);
  }

  /// Update entity using secure service
  Future<Map<String, dynamic>?> updateEntity(String filename, int id, Map<String, dynamic> updatedEntity) async {
    return await _secureService.updateEntity(filename, id, updatedEntity);
  }

  /// Delete entity using secure service
  Future<bool> deleteEntity(String filename, int id) async {
    return await _secureService.deleteEntity(filename, id);
  }

  Future<String?> saveImage(File imageFile, String entityType, int entityId) async {
    // Image saving not supported on web
    if (kIsWeb) return null;
    
    final dataDir = await _getDataDirectory();
    if (dataDir == null) return null;
    
    final imagesDir = Directory('${dataDir.path}/images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final extension = imageFile.path.split('.').last;
    final filename = '${entityType}_$entityId.$extension';
    final targetFile = File('${imagesDir.path}/$filename');
    await imageFile.copy(targetFile.path);
    return targetFile.path;
  }

  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
    }
  }
}


