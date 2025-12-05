import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../security/encryption_service.dart';
import '../security/secure_local_data_service.dart';
import '../../utils/logger.dart';

/// Service for creating and restoring encrypted backups
class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  final EncryptionService _encryption = EncryptionService();
  final SecureLocalDataService _dataService = SecureLocalDataService();
  Directory? _backupDirectory;

  /// Get backup directory
  Future<Directory> _getBackupDirectory() async {
    if (_backupDirectory != null) return _backupDirectory!;
    final appDir = await getApplicationDocumentsDirectory();
    _backupDirectory = Directory('${appDir.path}/backups');
    if (!await _backupDirectory!.exists()) {
      await _backupDirectory!.create(recursive: true);
    }
    return _backupDirectory!;
  }

  /// Create a timestamped backup
  Future<File> createBackup({bool includeImages = true}) async {
    try {
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final backupDir = await _getBackupDirectory();
      final backupFile = File('${backupDir.path}/backup_$timestamp.dfc');

      // Collect all data
      final backupData = <String, dynamic>{
        'version': '1.0',
        'timestamp': timestamp,
        'data': <String, dynamic>{},
      };

      // List of all JSON files to backup
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

      // Load all data
      for (var filename in jsonFiles) {
        try {
          final data = await _dataService.loadJson(filename);
          backupData['data']![filename] = data;
        } catch (e) {
          AppLogger.warning('Failed to backup $filename: $e');
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
                    'name': f.path.split('/').last,
                    'data': f.readAsBytesSync(),
                  })
              .toList();
          backupData['images'] = imageFiles;
        }
      }

      // Encrypt backup
      final jsonString = json.encode(backupData);
      final encryptedContent = _encryption.encryptString(jsonString);
      final checksum = _encryption.generateChecksum(jsonString);

      // Save backup
      await backupFile.writeAsString(encryptedContent);

      // Save checksum
      final checksumFile = File('${backupFile.path}.checksum');
      await checksumFile.writeAsString(checksum);

      // Save metadata
      final metadata = {
        'timestamp': timestamp,
        'size': await backupFile.length(),
        'includesImages': includeImages,
        'checksum': checksum,
      };
      final metadataFile = File('${backupFile.path}.meta');
      await metadataFile.writeAsString(json.encode(metadata));

      AppLogger.info('Backup created: ${backupFile.path}');
      return backupFile;
    } catch (e, stack) {
      AppLogger.error('Failed to create backup', e, stack);
      rethrow;
    }
  }

  /// List all available backups
  Future<List<BackupInfo>> listBackups() async {
    try {
      final backupDir = await _getBackupDirectory();
      if (!await backupDir.exists()) {
        return [];
      }

      final backups = <BackupInfo>[];
      final files = backupDir.listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.dfc'))
          .toList();

      for (var file in files) {
        try {
          final metadataFile = File('${file.path}.meta');
          if (await metadataFile.exists()) {
            final metadataJson = await metadataFile.readAsString();
            final metadata = json.decode(metadataJson) as Map<String, dynamic>;
            backups.add(BackupInfo(
              file: file,
              timestamp: DateTime.parse(metadata['timestamp'] as String),
              size: metadata['size'] as int,
              includesImages: metadata['includesImages'] as bool? ?? false,
            ));
          } else {
            // Fallback: use file modification time
            backups.add(BackupInfo(
              file: file,
              timestamp: await file.lastModified(),
              size: await file.length(),
              includesImages: false,
            ));
          }
        } catch (e) {
          AppLogger.warning('Failed to read backup metadata for ${file.path}: $e');
        }
      }

      backups.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return backups;
    } catch (e, stack) {
      AppLogger.error('Failed to list backups', e, stack);
      return [];
    }
  }

  /// Restore from backup
  Future<RestoreResult> restoreBackup(File backupFile, {bool preview = false}) async {
    try {
      // Verify checksum
      final checksumFile = File('${backupFile.path}.checksum');
      if (await checksumFile.exists()) {
        final expectedChecksum = await checksumFile.readAsString();
        final encryptedContent = await backupFile.readAsString();
        final decryptedContent = _encryption.decryptString(encryptedContent);
        
        if (!_encryption.verifyChecksum(decryptedContent, expectedChecksum)) {
          return RestoreResult(
            success: false,
            error: 'Backup file is corrupted or tampered with',
          );
        }
      }

      // Decrypt backup
      final encryptedContent = await backupFile.readAsString();
      final decryptedContent = _encryption.decryptString(encryptedContent);
      final backupData = json.decode(decryptedContent) as Map<String, dynamic>;

      if (preview) {
        // Return preview without restoring
        return RestoreResult(
          success: true,
          preview: _generatePreview(backupData),
        );
      }

      // Validate backup structure
      if (!backupData.containsKey('data') || backupData['data'] is! Map) {
        return RestoreResult(
          success: false,
          error: 'Invalid backup format',
        );
      }

      // Restore data
      final dataMap = backupData['data'] as Map<String, dynamic>;
      int restoredCount = 0;

      for (var entry in dataMap.entries) {
        try {
          final filename = entry.key;
          final data = entry.value as List<dynamic>;
          await _dataService.saveJson(filename, data);
          restoredCount++;
        } catch (e) {
          AppLogger.warning('Failed to restore ${entry.key}: $e');
        }
      }

      // Restore images if present
      int imageCount = 0;
      if (backupData.containsKey('images')) {
        final images = backupData['images'] as List<dynamic>;
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
            AppLogger.warning('Failed to restore image: $e');
          }
        }
      }

      // Clear cache
      _dataService.clearCache();

      AppLogger.info('Restored backup: $restoredCount files, $imageCount images');
      return RestoreResult(
        success: true,
        restoredFiles: restoredCount,
        restoredImages: imageCount,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to restore backup', e, stack);
      return RestoreResult(
        success: false,
        error: 'Failed to restore backup: $e',
      );
    }
  }

  /// Generate preview of backup contents
  Map<String, dynamic> _generatePreview(Map<String, dynamic> backupData) {
    final preview = <String, dynamic>{};
    
    if (backupData.containsKey('data')) {
      final dataMap = backupData['data'] as Map<String, dynamic>;
      preview['files'] = dataMap.map((key, value) => MapEntry(
            key,
            (value as List).length,
          ));
    }

    if (backupData.containsKey('images')) {
      preview['images'] = (backupData['images'] as List).length;
    }

    preview['timestamp'] = backupData['timestamp'];
    preview['version'] = backupData['version'];

    return preview;
  }

  /// Delete backup
  Future<bool> deleteBackup(File backupFile) async {
    try {
      await backupFile.delete();
      final checksumFile = File('${backupFile.path}.checksum');
      if (await checksumFile.exists()) {
        await checksumFile.delete();
      }
      final metadataFile = File('${backupFile.path}.meta');
      if (await metadataFile.exists()) {
        await metadataFile.delete();
      }
      return true;
    } catch (e) {
      AppLogger.error('Failed to delete backup', e);
      return false;
    }
  }
}

/// Backup information
class BackupInfo {
  final File file;
  final DateTime timestamp;
  final int size;
  final bool includesImages;

  BackupInfo({
    required this.file,
    required this.timestamp,
    required this.size,
    required this.includesImages,
  });
}

/// Restore result
class RestoreResult {
  final bool success;
  final String? error;
  final int? restoredFiles;
  final int? restoredImages;
  final Map<String, dynamic>? preview;

  RestoreResult({
    required this.success,
    this.error,
    this.restoredFiles,
    this.restoredImages,
    this.preview,
  });
}


