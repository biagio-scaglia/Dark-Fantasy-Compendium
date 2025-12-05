import '../models/weapon.dart';
import 'local_json_service.dart';
import 'json_converter.dart';

class WeaponService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Weapon>> getAll() async {
    final data = await _jsonService.loadJson('weapons.json');
    return data.map((json) => Weapon.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Weapon?> getById(int id) async {
    final entity = await _jsonService.getEntity('weapons.json', id);
    if (entity == null) return null;
    return Weapon.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Weapon> create(Weapon weapon) async {
    final json = weapon.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('weapons.json', json);
    return Weapon.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Weapon?> update(Weapon weapon) async {
    final json = weapon.toJson();
    final updated = await _jsonService.updateEntity('weapons.json', weapon.id, json);
    if (updated == null) return null;
    return Weapon.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('weapons.json', id);
  }
}


