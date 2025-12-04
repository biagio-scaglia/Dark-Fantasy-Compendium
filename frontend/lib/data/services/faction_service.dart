import '../models/faction.dart';
import 'local_json_service.dart';
import 'json_converter.dart';

class FactionService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Faction>> getAll() async {
    final data = await _jsonService.loadJson('factions.json');
    return data.map((json) => Faction.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Faction?> getById(int id) async {
    final entity = await _jsonService.getEntity('factions.json', id);
    if (entity == null) return null;
    return Faction.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Faction> create(Faction faction) async {
    final json = faction.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('factions.json', json);
    return Faction.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Faction?> update(Faction faction) async {
    final json = faction.toJson();
    final updated = await _jsonService.updateEntity('factions.json', faction.id, json);
    if (updated == null) return null;
    return Faction.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('factions.json', id);
  }
}

