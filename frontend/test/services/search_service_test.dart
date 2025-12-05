import 'package:flutter_test/flutter_test.dart';
import 'package:dark_fantasy_compendium/core/search/search_service.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('SearchService', () {
    late SearchService service;

    setUp(() {
      service = SearchService();
    });

    test('should index collection', () {
      final items = [
        MockData.createCharacter(id: 1, name: 'Warrior'),
        MockData.createCharacter(id: 2, name: 'Mage'),
        MockData.createCharacter(id: 3, name: 'Rogue'),
      ];

      service.indexCollection('characters', items);
      expect(service, isNotNull);
    });

    test('should search by keyword', () {
      final items = [
        MockData.createCharacter(id: 1, name: 'Warrior'),
        MockData.createCharacter(id: 2, name: 'Mage'),
        MockData.createCharacter(id: 3, name: 'Rogue'),
      ];

      service.indexCollection('characters', items);
      final results = service.search('characters', 'Warrior');

      expect(results.length, greaterThan(0));
      expect(results[0]['name'], contains('Warrior'));
    });

    test('should return empty for no matches', () {
      final items = [MockData.createCharacter(id: 1, name: 'Warrior')];
      service.indexCollection('characters', items);

      final results = service.search('characters', 'NonExistent');

      expect(results, isEmpty);
    });

    test('should search across all collections', () {
      final characters = [MockData.createCharacter(id: 1, name: 'Warrior')];
      final items = [MockData.createItem(id: 1, name: 'Sword')];

      service.indexCollection('characters', characters);
      service.indexCollection('items', items);

      final results = service.searchAll('Warrior');

      expect(results.containsKey('characters'), isTrue);
      expect(results['characters']!.length, greaterThan(0));
    });

    test('should handle empty query', () {
      final items = [MockData.createCharacter(id: 1, name: 'Warrior')];
      service.indexCollection('characters', items);

      final results = service.search('characters', '');

      expect(results.length, equals(1));
    });

    test('should clear index', () {
      final items = [MockData.createCharacter(id: 1, name: 'Warrior')];
      service.indexCollection('characters', items);
      service.clearIndex('characters');

      final results = service.search('characters', 'Warrior');
      expect(results, isEmpty);
    });
  });
}

