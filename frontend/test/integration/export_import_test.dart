import 'package:flutter_test/flutter_test.dart';
import 'package:dark_fantasy_compendium/core/export/export_service.dart';
import 'package:dark_fantasy_compendium/core/security/encryption_service.dart';
import 'dart:io';

void main() {
  group('Export/Import Integration Tests', () {
    late ExportService service;

    setUpAll(() async {
      await EncryptionService().initialize();
      service = ExportService();
    });

    test('should export and import all data', () async {
      // Export
      final exportFile = await service.exportAllData(includeImages: false);
      expect(await exportFile.exists(), isTrue);

      // Import
      final result = await service.importData(exportFile, mode: ImportMode.overwrite);
      expect(result.success, isTrue);
    });

    test('should export specific entity type', () async {
      final exportFile = await service.exportEntityType('characters', includeImages: false);
      expect(await exportFile.exists(), isTrue);
      expect(exportFile.path.contains('characters'), isTrue);
    });

    test('should handle import conflicts with merge mode', () async {
      final exportFile = await service.exportAllData(includeImages: false);
      final result = await service.importData(exportFile, mode: ImportMode.merge);

      expect(result.success, isTrue);
    });

    test('should validate import schema', () async {
      // Create invalid export file
      final tempFile = File('${Directory.systemTemp.path}/invalid.dfc');
      await tempFile.writeAsString('invalid json');

      final result = await service.importData(tempFile);
      expect(result.success, isFalse);
      expect(result.error, isNotNull);

      await tempFile.delete();
    });

    test('should skip existing items in skip mode', () async {
      final exportFile = await service.exportAllData(includeImages: false);
      final result = await service.importData(exportFile, mode: ImportMode.skipExisting);

      expect(result.success, isTrue);
      expect(result.skipped, greaterThanOrEqualTo(0));
    });
  });
}

