import '../models/item.dart';
import '../models/character.dart';
import 'local_json_service.dart';
import 'json_converter.dart';
import 'character_service.dart';

class ItemService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Item>> getAll() async {
    final data = await _jsonService.loadJson('items.json');
    return data.map((json) => Item.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Item?> getById(int id) async {
    final entity = await _jsonService.getEntity('items.json', id);
    if (entity == null) return null;
    return Item.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Item> create(Item item) async {
    final json = item.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('items.json', json);
    return Item.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Item?> update(Item item) async {
    final json = item.toJson();
    final updated = await _jsonService.updateEntity('items.json', item.id, json);
    if (updated == null) return null;
    return Item.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('items.json', id);
  }

  Future<Character?> getOwner(Item item) async {
    if (item.ownerId == null) return null;
    final characterService = CharacterService();
    return await characterService.getById(item.ownerId!);
  }

  Future<List<Item>> getByOwnerId(int ownerId) async {
    final all = await getAll();
    return all.where((item) => item.ownerId == ownerId).toList();
  }
}

