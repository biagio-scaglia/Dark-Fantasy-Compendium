import '../models/ability.dart';
import 'local_json_service.dart';
import 'json_converter.dart';

class AbilityService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Ability>> getAll() async {
    final data = await _jsonService.loadJson('abilities.json');
    return data.map((json) => Ability.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Ability?> getById(int id) async {
    final entity = await _jsonService.getEntity('abilities.json', id);
    if (entity == null) return null;
    return Ability.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Ability> create(Ability ability) async {
    final json = ability.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('abilities.json', json);
    return Ability.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Ability?> update(Ability ability) async {
    final json = ability.toJson();
    final updated = await _jsonService.updateEntity('abilities.json', ability.id, json);
    if (updated == null) return null;
    return Ability.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('abilities.json', id);
  }
}

