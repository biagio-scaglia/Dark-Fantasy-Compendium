import 'package:flutter_test/flutter_test.dart';
import 'package:dark_fantasy_compendium/core/security/secure_local_data_service.dart';
import 'package:dark_fantasy_compendium/core/security/encryption_service.dart';
import '../helpers/test_helpers.dart';
import 'dart:io';

void main() {
  group('SecureLocalDataService', () {
    late SecureLocalDataService service;
    late Directory testDir;

    setUpAll(() async {
      service = SecureLocalDataService();
      await EncryptionService().initialize();
      await service.initialize();
    });

    setUp(() async {
      testDir = await TestHelpers.getTestDirectory();
    });

    tearDown(() async {
      await TestHelpers.cleanupTestDirectory(testDir);
    });

    test('should initialize successfully', () async {
      expect(service, isNotNull);
    });

    test('should save and load JSON data', () async {
      final testData = [
        MockData.createCharacter(id: 1, name: 'Test Character'),
        MockData.createCharacter(id: 2, name: 'Another Character'),
      ];

      await service.saveJson('test.json', testData);
      final loaded = await service.loadJson('test.json');

      expect(loaded.length, equals(2));
      expect(loaded[0]['name'], equals('Test Character'));
      expect(loaded[1]['name'], equals('Another Character'));
    });

    test('should create entity with auto-generated ID', () async {
      final entity = {'name': 'New Entity'};
      final created = await service.createEntity('test.json', entity);

      expect(created['id'], isNotNull);
      expect(created['name'], equals('New Entity'));
    });

    test('should get entity by ID', () async {
      final testData = [
        MockData.createCharacter(id: 1, name: 'Character 1'),
        MockData.createCharacter(id: 2, name: 'Character 2'),
      ];

      await service.saveJson('test.json', testData);
      final entity = await service.getEntity('test.json', 1);

      expect(entity, isNotNull);
      expect(entity!['name'], equals('Character 1'));
    });

    test('should update entity', () async {
      final testData = [MockData.createCharacter(id: 1, name: 'Original')];
      await service.saveJson('test.json', testData);

      final updated = {'id': 1, 'name': 'Updated'};
      final result = await service.updateEntity('test.json', 1, updated);

      expect(result, isNotNull);
      expect(result!['name'], equals('Updated'));

      final loaded = await service.loadJson('test.json');
      expect(loaded[0]['name'], equals('Updated'));
    });

    test('should delete entity', () async {
      final testData = [
        MockData.createCharacter(id: 1, name: 'Character 1'),
        MockData.createCharacter(id: 2, name: 'Character 2'),
      ];

      await service.saveJson('test.json', testData);
      final deleted = await service.deleteEntity('test.json', 1);

      expect(deleted, isTrue);

      final loaded = await service.loadJson('test.json');
      expect(loaded.length, equals(1));
      expect(loaded[0]['id'], equals(2));
    });

    test('should validate data structure', () {
      final invalidData = [
        {'name': 'No ID'},
      ];

      expect(
        () => service.saveJson('test.json', invalidData),
        throwsException,
      );
    });

    test('should handle empty data', () async {
      await service.saveJson('test.json', []);
      final loaded = await service.loadJson('test.json');

      expect(loaded, isEmpty);
    });
  });
}

