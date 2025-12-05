import 'dart:convert';
import 'dart:io';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import '../security/secure_local_data_service.dart';
import '../export/export_service.dart';
import '../../utils/logger.dart';

/// Service for local-only data synchronization
/// Supports QR code-based device-to-device sync
class LocalSyncService {
  static final LocalSyncService _instance = LocalSyncService._internal();
  factory LocalSyncService() => _instance;
  LocalSyncService._internal();

  final SecureLocalDataService _dataService = SecureLocalDataService();
  final ExportService _exportService = ExportService();

  /// Generate sync data package for QR code
  Future<SyncPackage> generateSyncPackage({
    List<String>? entityTypes,
    bool includeImages = false,
  }) async {
    try {
      // Export selected data
      final exportFile = entityTypes == null
          ? await _exportService.exportAllData(includeImages: includeImages)
          : await _exportMultipleEntityTypes(entityTypes, includeImages);

      // Read export file
      final exportData = await exportFile.readAsString();
      
      // Create sync package
      final package = SyncPackage(
        version: '1.0',
        timestamp: DateTime.now().toIso8601String(),
        entityTypes: entityTypes ?? _getAllEntityTypes(),
        dataSize: exportData.length,
        checksum: _generateChecksum(exportData),
        data: exportData,
      );

      AppLogger.info('Generated sync package: ${package.entityTypes.length} entity types');
      return package;
    } catch (e, stack) {
      AppLogger.error('Failed to generate sync package', e, stack);
      rethrow;
    }
  }

  /// Generate QR code widget for sync package
  Widget generateQrCode(SyncPackage package, {double size = 200}) {
    final jsonData = json.encode({
      'version': package.version,
      'timestamp': package.timestamp,
      'entityTypes': package.entityTypes,
      'dataSize': package.dataSize,
      'checksum': package.checksum,
      'data': package.data,
    });

    return QrImageView(
      data: jsonData,
      version: QrVersions.auto,
      size: size,
      backgroundColor: Colors.white,
    );
  }

  /// Parse sync package from QR code data
  Future<SyncPackage> parseSyncPackage(String qrData) async {
    try {
      final jsonData = json.decode(qrData) as Map<String, dynamic>;
      
      final package = SyncPackage(
        version: jsonData['version'] as String,
        timestamp: jsonData['timestamp'] as String,
        entityTypes: (jsonData['entityTypes'] as List).cast<String>(),
        dataSize: jsonData['dataSize'] as int,
        checksum: jsonData['checksum'] as String,
        data: jsonData['data'] as String,
      );

      // Verify checksum
      if (!_verifyChecksum(package.data, package.checksum)) {
        throw Exception('Sync package checksum verification failed');
      }

      return package;
    } catch (e) {
      AppLogger.error('Failed to parse sync package', e);
      rethrow;
    }
  }

  /// Apply sync package with conflict resolution
  Future<SyncResult> applySyncPackage(
    SyncPackage package, {
    ConflictResolutionMode mode = ConflictResolutionMode.lastUpdated,
  }) async {
    try {
      // Import the data
      final tempFile = await _createTempFile(package.data);
      final importResult = await _exportService.importData(
        tempFile,
        mode: _convertConflictMode(mode),
      );

      // Clean up temp file
      await tempFile.delete();

      if (!importResult.success) {
        return SyncResult(
          success: false,
          error: importResult.error,
        );
      }

      AppLogger.info('Applied sync package: ${importResult.importedFiles} files');
      return SyncResult(
        success: true,
        syncedFiles: importResult.importedFiles ?? 0,
        syncedImages: importResult.importedImages ?? 0,
        conflicts: importResult.conflicts,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to apply sync package', e, stack);
      return SyncResult(
        success: false,
        error: 'Failed to apply sync: $e',
      );
    }
  }

  /// Get version info for a dataset
  Future<DatasetVersion> getDatasetVersion(String entityType) async {
    try {
      final data = await _dataService.loadJson('$entityType.json');
      final lastModified = DateTime.now(); // In real implementation, track this
      
      return DatasetVersion(
        entityType: entityType,
        version: '1.0',
        itemCount: data.length,
        lastModified: lastModified,
        checksum: _generateChecksum(json.encode(data)),
      );
    } catch (e) {
      AppLogger.error('Failed to get dataset version', e);
      rethrow;
    }
  }

  /// Compare versions and detect conflicts
  Future<List<VersionConflict>> detectConflicts(
    List<DatasetVersion> localVersions,
    List<DatasetVersion> remoteVersions,
  ) async {
    final conflicts = <VersionConflict>[];

    for (var remote in remoteVersions) {
      final local = localVersions.firstWhere(
        (v) => v.entityType == remote.entityType,
        orElse: () => DatasetVersion(
          entityType: remote.entityType,
          version: '0.0',
          itemCount: 0,
          lastModified: DateTime(1970),
          checksum: '',
        ),
      );

      if (local.checksum != remote.checksum) {
        conflicts.add(VersionConflict(
          entityType: remote.entityType,
          localVersion: local,
          remoteVersion: remote,
          conflictType: _determineConflictType(local, remote),
        ));
      }
    }

    return conflicts;
  }

  // Helper methods

  Future<File> _exportMultipleEntityTypes(
    List<String> entityTypes,
    bool includeImages,
  ) async {
    // For simplicity, export all and filter later
    // In production, implement per-entity export
    return await _exportService.exportAllData(includeImages: includeImages);
  }

  List<String> _getAllEntityTypes() {
    return [
      'characters',
      'campaigns',
      'parties',
      'items',
      'spells',
      'races',
      'dnd_classes',
      'maps',
      'bosses',
      'factions',
      'armors',
      'weapons',
      'knights',
      'lores',
      'abilities',
    ];
  }

  String _generateChecksum(String data) {
    // Simple checksum - in production use SHA-256
    return data.length.toString();
  }

  bool _verifyChecksum(String data, String expectedChecksum) {
    return _generateChecksum(data) == expectedChecksum;
  }

  Future<File> _createTempFile(String data) async {
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/sync_${DateTime.now().millisecondsSinceEpoch}.dfc');
    await tempFile.writeAsString(data);
    return tempFile;
  }

  ImportMode _convertConflictMode(ConflictResolutionMode mode) {
    switch (mode) {
      case ConflictResolutionMode.lastUpdated:
        return ImportMode.merge;
      case ConflictResolutionMode.overwrite:
        return ImportMode.overwrite;
      case ConflictResolutionMode.skip:
        return ImportMode.skipExisting;
    }
  }

  ConflictType _determineConflictType(DatasetVersion local, DatasetVersion remote) {
    if (local.lastModified.isAfter(remote.lastModified)) {
      return ConflictType.localNewer;
    } else if (remote.lastModified.isAfter(local.lastModified)) {
      return ConflictType.remoteNewer;
    } else {
      return ConflictType.diverged;
    }
  }
}

/// Sync package for data transfer
class SyncPackage {
  final String version;
  final String timestamp;
  final List<String> entityTypes;
  final int dataSize;
  final String checksum;
  final String data;

  SyncPackage({
    required this.version,
    required this.timestamp,
    required this.entityTypes,
    required this.dataSize,
    required this.checksum,
    required this.data,
  });
}

/// Sync result
class SyncResult {
  final bool success;
  final String? error;
  final int? syncedFiles;
  final int? syncedImages;
  final Map<String, int> conflicts;

  SyncResult({
    required this.success,
    this.error,
    this.syncedFiles,
    this.syncedImages,
    this.conflicts = const {},
  });
}

/// Dataset version info
class DatasetVersion {
  final String entityType;
  final String version;
  final int itemCount;
  final DateTime lastModified;
  final String checksum;

  DatasetVersion({
    required this.entityType,
    required this.version,
    required this.itemCount,
    required this.lastModified,
    required this.checksum,
  });
}

/// Version conflict
class VersionConflict {
  final String entityType;
  final DatasetVersion localVersion;
  final DatasetVersion remoteVersion;
  final ConflictType conflictType;

  VersionConflict({
    required this.entityType,
    required this.localVersion,
    required this.remoteVersion,
    required this.conflictType,
  });
}

/// Conflict resolution modes
enum ConflictResolutionMode {
  lastUpdated, // Use most recent version
  overwrite, // Always use remote
  skip, // Skip conflicts
}

/// Conflict types
enum ConflictType {
  localNewer,
  remoteNewer,
  diverged,
}


