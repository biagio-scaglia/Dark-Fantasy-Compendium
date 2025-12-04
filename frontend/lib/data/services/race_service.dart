import '../models/race.dart';
import 'local_json_service.dart';
import 'json_converter.dart';

class RaceService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Race>> getAll() async {
    final data = await _jsonService.loadJson('races.json');
    return data.map((json) => Race.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Race?> getById(int id) async {
    final entity = await _jsonService.getEntity('races.json', id);
    if (entity == null) return null;
    return Race.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Race> create(Race race) async {
    final json = race.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('races.json', json);
    return Race.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Race?> update(Race race) async {
    final json = race.toJson();
    final updated = await _jsonService.updateEntity('races.json', race.id, json);
    if (updated == null) return null;
    return Race.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('races.json', id);
  }
}

