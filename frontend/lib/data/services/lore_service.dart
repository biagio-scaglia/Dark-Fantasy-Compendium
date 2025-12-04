import '../models/lore.dart';
import 'local_json_service.dart';
import 'json_converter.dart';

class LoreService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Lore>> getAll() async {
    final data = await _jsonService.loadJson('lores.json');
    return data.map((json) => Lore.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Lore?> getById(int id) async {
    final entity = await _jsonService.getEntity('lores.json', id);
    if (entity == null) return null;
    return Lore.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Lore> create(Lore lore) async {
    final json = lore.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('lores.json', json);
    return Lore.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Lore?> update(Lore lore) async {
    final json = lore.toJson();
    final updated = await _jsonService.updateEntity('lores.json', lore.id, json);
    if (updated == null) return null;
    return Lore.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('lores.json', id);
  }
}

