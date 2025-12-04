import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class LocalJsonService {
  static final LocalJsonService _instance = LocalJsonService._internal();
  factory LocalJsonService() => _instance;
  LocalJsonService._internal();

  Directory? _dataDirectory;

  Future<Directory> _getDataDirectory() async {
    if (_dataDirectory != null) return _dataDirectory!;
    final appDir = await getApplicationDocumentsDirectory();
    _dataDirectory = Directory('${appDir.path}/data');
    if (!await _dataDirectory!.exists()) {
      await _dataDirectory!.create(recursive: true);
    }
    return _dataDirectory!;
  }

  Future<String> _getAssetPath(String filename) async {
    return 'assets/data/$filename';
  }

  Future<String> _getLocalPath(String filename) async {
    final dataDir = await _getDataDirectory();
    return '${dataDir.path}/$filename';
  }

  Future<List<dynamic>> loadJson(String filename) async {
    try {
      final localPath = await _getLocalPath(filename);
      final localFile = File(localPath);
      
      if (await localFile.exists()) {
        final content = await localFile.readAsString();
        return json.decode(content) as List<dynamic>;
      }
      
      final assetPath = await _getAssetPath(filename);
      final content = await rootBundle.loadString(assetPath);
      final data = json.decode(content) as List<dynamic>;
      
      await saveJson(filename, data);
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveJson(String filename, List<dynamic> data) async {
    try {
      final localPath = await _getLocalPath(filename);
      final localFile = File(localPath);
      await localFile.writeAsString(json.encode(data));
    } catch (e) {
      throw Exception('Failed to save $filename: $e');
    }
  }

  Future<Map<String, dynamic>> createEntity(String filename, Map<String, dynamic> entity) async {
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

  Future<Map<String, dynamic>?> getEntity(String filename, int id) async {
    final data = await loadJson(filename);
    try {
      return data.firstWhere((e) => e['id'] == id) as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>> getAllEntities(String filename) async {
    return await loadJson(filename);
  }

  Future<Map<String, dynamic>?> updateEntity(String filename, int id, Map<String, dynamic> updatedEntity) async {
    final data = await loadJson(filename);
    final index = data.indexWhere((e) => e['id'] == id);
    if (index == -1) return null;
    updatedEntity['id'] = id;
    data[index] = updatedEntity;
    await saveJson(filename, data);
    return updatedEntity as Map<String, dynamic>?;
  }

  Future<bool> deleteEntity(String filename, int id) async {
    final data = await loadJson(filename);
    final index = data.indexWhere((e) => e['id'] == id);
    if (index == -1) return false;
    data.removeAt(index);
    await saveJson(filename, data);
    return true;
  }

  Future<String> saveImage(File imageFile, String entityType, int entityId) async {
    final dataDir = await _getDataDirectory();
    final imagesDir = Directory('${dataDir.path}/images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final extension = imageFile.path.split('.').last;
    final filename = '${entityType}_${entityId}.$extension';
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

