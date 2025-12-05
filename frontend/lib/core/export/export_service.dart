import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../security/encryption_service.dart';
import '../security/secure_local_data_service.dart';
import '../../utils/logger.dart';

/// Service for exporting and importing data
class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  final EncryptionService _encryption = EncryptionService();
  final SecureLocalDataService _dataService = SecureLocalDataService();

  /// Export all data to encrypted file
  Future<File> exportAllData({bool includeImages = true}) async {
    try {
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final appDir = await getApplicationDocumentsDirectory();
      final exportFile = File('${appDir.path}/export_$timestamp.dfc');

      final exportData = <String, dynamic>{
        'version': '1.0',
        'timestamp': timestamp,
        'data': <String, dynamic>{},
      };

      // Export all JSON files
      final jsonFiles = [
        'characters.json',
        'campaigns.json',
        'parties.json',
        'items.json',
        'spells.json',
        'races.json',
        'dnd_classes.json',
        'maps.json',
        'bosses.json',
        'factions.json',
        'armors.json',
        'weapons.json',
        'knights.json',
        'lores.json',
        'abilities.json',
      ];

      for (var filename in jsonFiles) {
        try {
          final data = await _dataService.loadJson(filename);
          exportData['data']![filename] = data;
        } catch (e) {
          AppLogger.warning('Failed to export $filename: $e');
        }
      }

      // Include images if requested
      if (includeImages) {
        final dataDirPath = await _dataService.getDataDirectoryPath();
        final imagesDir = Directory('$dataDirPath/images');
        if (await imagesDir.exists()) {
          final imageFiles = imagesDir.listSync()
              .whereType<File>()
              .map((f) => {
                    'name': f.path.split(Platform.pathSeparator).last,
                    'data': f.readAsBytesSync(),
                  })
              .toList();
          exportData['images'] = imageFiles;
        }
      }

      // Encrypt export
      final jsonString = json.encode(exportData);
      final encryptedContent = _encryption.encryptString(jsonString);
      final checksum = _encryption.generateChecksum(jsonString);

      await exportFile.writeAsString(encryptedContent);

      // Save checksum
      final checksumFile = File('${exportFile.path}.checksum');
      await checksumFile.writeAsString(checksum);

      AppLogger.info('Data exported to: ${exportFile.path}');
      return exportFile;
    } catch (e, stack) {
      AppLogger.error('Failed to export data', e, stack);
      rethrow;
    }
  }

  /// Export specific entity type
  Future<File> exportEntityType(String entityType, {bool includeImages = true}) async {
    try {
      final filename = '$entityType.json';
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final appDir = await getApplicationDocumentsDirectory();
      final exportFile = File('${appDir.path}/export_${entityType}_$timestamp.dfc');

      final exportData = <String, dynamic>{
        'version': '1.0',
        'timestamp': timestamp,
        'entityType': entityType,
        'data': <String, dynamic>{},
      };

      // Export specific entity type
      final data = await _dataService.loadJson(filename);
      exportData['data']![filename] = data;

      // Include related images if requested
      if (includeImages) {
        final dataDirPath = await _dataService.getDataDirectoryPath();
        final imagesDir = Directory('$dataDirPath/images');
        if (await imagesDir.exists()) {
          final entityImages = imagesDir.listSync()
              .whereType<File>()
              .where((f) => f.path.contains('${entityType}_'))
              .map((f) => {
                    'name': f.path.split(Platform.pathSeparator).last,
                    'data': f.readAsBytesSync(),
                  })
              .toList();
          exportData['images'] = entityImages;
        }
      }

      // Encrypt export
      final jsonString = json.encode(exportData);
      final encryptedContent = _encryption.encryptString(jsonString);
      final checksum = _encryption.generateChecksum(jsonString);

      await exportFile.writeAsString(encryptedContent);

      // Save checksum
      final checksumFile = File('${exportFile.path}.checksum');
      await checksumFile.writeAsString(checksum);

      AppLogger.info('Exported $entityType to: ${exportFile.path}');
      return exportFile;
    } catch (e, stack) {
      AppLogger.error('Failed to export $entityType', e, stack);
      rethrow;
    }
  }

  /// Import data from encrypted file
  Future<ImportResult> importData(File importFile, {ImportMode mode = ImportMode.merge}) async {
    try {
      // Verify checksum
      final checksumFile = File('${importFile.path}.checksum');
      if (await checksumFile.exists()) {
        final expectedChecksum = await checksumFile.readAsString();
        final encryptedContent = await importFile.readAsString();
        final decryptedContent = _encryption.decryptString(encryptedContent);
        
        if (!_encryption.verifyChecksum(decryptedContent, expectedChecksum)) {
          return ImportResult(
            success: false,
            error: 'Import file is corrupted or tampered with',
          );
        }
      }

      // Decrypt import
      final encryptedContent = await importFile.readAsString();
      final decryptedContent = _encryption.decryptString(encryptedContent);
      final importData = json.decode(decryptedContent) as Map<String, dynamic>;

      // Validate schema
      final validationResult = _validateSchema(importData);
      if (!validationResult.isValid) {
        return ImportResult(
          success: false,
          error: 'Invalid import schema: ${validationResult.error}',
        );
      }

      // Import data based on mode
      final dataMap = importData['data'] as Map<String, dynamic>;
      int importedCount = 0;
      int skippedCount = 0;
      final conflicts = <String, int>{};

      for (var entry in dataMap.entries) {
        try {
          final filename = entry.key;
          final importedData = entry.value as List<dynamic>;
          final existingData = await _dataService.loadJson(filename);

          List<dynamic> finalData;
          switch (mode) {
            case ImportMode.overwrite:
              finalData = importedData;
              break;
            case ImportMode.merge:
              finalData = _mergeData(existingData, importedData, filename, conflicts);
              break;
            case ImportMode.skipExisting:
              finalData = _skipExisting(existingData, importedData, filename, skippedCount);
              break;
          }

          await _dataService.saveJson(filename, finalData);
          importedCount++;
        } catch (e) {
          AppLogger.warning('Failed to import ${entry.key}: $e');
        }
      }

      // Import images if present
      int imageCount = 0;
      if (importData.containsKey('images')) {
        final images = importData['images'] as List<dynamic>;
        final dataDirPath = await _dataService.getDataDirectoryPath();
        final imagesDir = Directory('$dataDirPath/images');
        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }

        for (var imageData in images) {
          try {
            final imageMap = imageData as Map<String, dynamic>;
            final name = imageMap['name'] as String;
            final bytes = (imageMap['data'] as List).cast<int>();
            final imageFile = File('${imagesDir.path}/$name');
            await imageFile.writeAsBytes(bytes);
            imageCount++;
          } catch (e) {
            AppLogger.warning('Failed to import image: $e');
          }
        }
      }

      // Clear cache
      _dataService.clearCache();

      AppLogger.info('Imported data: $importedCount files, $imageCount images');
      return ImportResult(
        success: true,
        importedFiles: importedCount,
        importedImages: imageCount,
        conflicts: conflicts,
        skipped: skippedCount,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to import data', e, stack);
      return ImportResult(
        success: false,
        error: 'Failed to import: $e',
      );
    }
  }

  /// Validate import schema
  SchemaValidationResult _validateSchema(Map<String, dynamic> data) {
    if (!data.containsKey('version')) {
      return SchemaValidationResult(isValid: false, error: 'Missing version');
    }

    if (!data.containsKey('data') || data['data'] is! Map) {
      return SchemaValidationResult(isValid: false, error: 'Missing or invalid data field');
    }

    final dataMap = data['data'] as Map<String, dynamic>;
    for (var entry in dataMap.entries) {
      if (entry.value is! List) {
        return SchemaValidationResult(
          isValid: false,
          error: 'Invalid data format for ${entry.key}',
        );
      }
    }

    return SchemaValidationResult(isValid: true);
  }

  /// Merge data with conflict resolution
  List<dynamic> _mergeData(
    List<dynamic> existing,
    List<dynamic> imported,
    String filename,
    Map<String, int> conflicts,
  ) {
    final existingIds = existing.map((e) => e['id'] as int).toSet();
    final merged = List<dynamic>.from(existing);
    int conflictCount = 0;

    for (var item in imported) {
      final id = item['id'] as int;
      if (existingIds.contains(id)) {
        // Conflict: use imported version (last updated wins)
        final index = merged.indexWhere((e) => e['id'] == id);
        if (index != -1) {
          merged[index] = item;
          conflictCount++;
        }
      } else {
        merged.add(item);
      }
    }

    if (conflictCount > 0) {
      conflicts[filename] = conflictCount;
    }

    return merged;
  }

  /// Skip existing items
  List<dynamic> _skipExisting(
    List<dynamic> existing,
    List<dynamic> imported,
    String filename,
    int skippedCount,
  ) {
    final existingIds = existing.map((e) => e['id'] as int).toSet();
    final merged = List<dynamic>.from(existing);

    for (var item in imported) {
      final id = item['id'] as int;
      if (!existingIds.contains(id)) {
        merged.add(item);
      } else {
        skippedCount++;
      }
    }

    return merged;
  }
}

/// Import modes
enum ImportMode {
  overwrite, // Replace all existing data
  merge, // Merge with existing, imported wins on conflicts
  skipExisting, // Only add new items
}

/// Import result
class ImportResult {
  final bool success;
  final String? error;
  final int? importedFiles;
  final int? importedImages;
  final Map<String, int> conflicts;
  final int skipped;

  ImportResult({
    required this.success,
    this.error,
    this.importedFiles,
    this.importedImages,
    this.conflicts = const {},
    this.skipped = 0,
  });
}

/// Schema validation result
class SchemaValidationResult {
  final bool isValid;
  final String? error;

  SchemaValidationResult({required this.isValid, this.error});
}


