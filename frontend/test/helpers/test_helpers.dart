import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dart:io';

/// Test helpers for file system operations
class TestHelpers {
  /// Get a temporary directory for tests
  static Future<Directory> getTestDirectory() async {
    final tempDir = Directory.systemTemp;
    final testDir = Directory('${tempDir.path}/test_${DateTime.now().millisecondsSinceEpoch}');
    await testDir.create(recursive: true);
    return testDir;
  }

  /// Clean up test directory
  static Future<void> cleanupTestDirectory(Directory dir) async {
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  /// Create mock JSON file
  static Future<File> createMockJsonFile(Directory dir, String filename, List<Map<String, dynamic>> data) async {
    final file = File('${dir.path}/$filename');
    await file.writeAsString(
      '[${data.map((e) => '{"id":${e['id']},"name":"${e['name']}"}').join(',')}]',
    );
    return file;
  }

  /// Create mock encrypted file
  static Future<File> createMockEncryptedFile(Directory dir, String filename, String content) async {
    final file = File('${dir.path}/$filename.enc');
    await file.writeAsString(content);
    return file;
  }

  /// Create mock checksum file
  static Future<File> createMockChecksumFile(Directory dir, String filename, String checksum) async {
    final file = File('${dir.path}/$filename.enc.checksum');
    await file.writeAsString(checksum);
    return file;
  }
}

/// Mock data generators
class MockData {
  static Map<String, dynamic> createCharacter({
    int id = 1,
    String name = 'Test Character',
    int level = 1,
    int? classId,
    int? raceId,
  }) {
    return {
      'id': id,
      'name': name,
      'level': level,
      'class_id': classId,
      'race_id': raceId,
      'stats': {
        'strength': 10,
        'dexterity': 10,
        'constitution': 10,
        'intelligence': 10,
        'wisdom': 10,
        'charisma': 10,
      },
    };
  }

  static Map<String, dynamic> createCampaign({
    int id = 1,
    String name = 'Test Campaign',
    String? dungeonMaster,
  }) {
    return {
      'id': id,
      'name': name,
      'dungeon_master': dungeonMaster ?? 'Test DM',
      'players': [],
      'character_ids': [],
      'sessions': [],
    };
  }

  static Map<String, dynamic> createItem({
    int id = 1,
    String name = 'Test Item',
    String type = 'weapon',
  }) {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': 'Test description',
    };
  }
}

/// Widget test helpers
class WidgetTestHelpers {
  /// Find text in widget tree
  static Finder findText(String text) {
    return find.text(text);
  }

  /// Find widget by type
  static Finder findWidgetByType<T>() {
    return find.byType(T);
  }

  /// Find widget by key
  static Finder findWidgetByKey(Key key) {
    return find.byKey(key);
  }

  /// Tap widget
  static Future<void> tapWidget(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Enter text
  static Future<void> enterText(WidgetTester tester, Finder finder, String text) async {
    await tester.tap(finder);
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }
}

