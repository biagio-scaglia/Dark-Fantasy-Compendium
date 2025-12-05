import 'package:flutter_test/flutter_test.dart';
import 'package:dark_fantasy_compendium/core/backup/backup_service.dart';
import 'package:dark_fantasy_compendium/core/security/encryption_service.dart';

void main() {
  group('BackupService', () {
    late BackupService service;

    setUpAll(() async {
      await EncryptionService().initialize();
      service = BackupService();
    });

    test('should create backup', () async {
      final backup = await service.createBackup(includeImages: false);

      expect(backup, isNotNull);
      expect(await backup.exists(), isTrue);
      expect(backup.path.endsWith('.dfc'), isTrue);
    });

    test('should list backups', () async {
      await service.createBackup(includeImages: false);
      final backups = await service.listBackups();

      expect(backups.length, greaterThan(0));
      expect(backups[0].timestamp, isNotNull);
      expect(backups[0].size, greaterThan(0));
    });

    test('should restore backup with preview', () async {
      final backup = await service.createBackup(includeImages: false);
      final result = await service.restoreBackup(backup, preview: true);

      expect(result.success, isTrue);
      expect(result.preview, isNotNull);
      expect(result.preview!['files'], isNotNull);
    });

    test('should delete backup', () async {
      final backup = await service.createBackup(includeImages: false);
      final deleted = await service.deleteBackup(backup);

      expect(deleted, isTrue);
      expect(await backup.exists(), isFalse);
    });

    test('should verify checksum on restore', () async {
      final backup = await service.createBackup(includeImages: false);
      
      // Corrupt the backup
      await backup.writeAsString('corrupted data');
      
      final result = await service.restoreBackup(backup, preview: false);
      
      // Should fail checksum verification
      expect(result.success, isFalse);
      expect(result.error, contains('corrupted'));
    });
  });
}

