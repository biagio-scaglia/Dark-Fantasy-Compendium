import '../models/armor.dart';
import 'local_json_service.dart';
import 'json_converter.dart';

class ArmorService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Armor>> getAll() async {
    final data = await _jsonService.loadJson('armors.json');
    return data.map((json) => Armor.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Armor?> getById(int id) async {
    final entity = await _jsonService.getEntity('armors.json', id);
    if (entity == null) return null;
    return Armor.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Armor> create(Armor armor) async {
    final json = armor.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('armors.json', json);
    return Armor.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Armor?> update(Armor armor) async {
    final json = armor.toJson();
    final updated = await _jsonService.updateEntity('armors.json', armor.id, json);
    if (updated == null) return null;
    return Armor.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('armors.json', id);
  }
}

