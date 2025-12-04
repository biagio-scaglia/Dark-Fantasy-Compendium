import '../models/knight.dart';
import '../models/faction.dart';
import '../models/weapon.dart';
import '../models/armor.dart';
import 'local_json_service.dart';
import 'json_converter.dart';
import 'faction_service.dart';
import 'weapon_service.dart';
import 'armor_service.dart';

class KnightService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Knight>> getAll() async {
    final data = await _jsonService.loadJson('knights.json');
    return data.map((json) => Knight.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Knight?> getById(int id) async {
    final entity = await _jsonService.getEntity('knights.json', id);
    if (entity == null) return null;
    return Knight.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Knight> create(Knight knight) async {
    final json = knight.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('knights.json', json);
    return Knight.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Knight?> update(Knight knight) async {
    final json = knight.toJson();
    final updated = await _jsonService.updateEntity('knights.json', knight.id, json);
    if (updated == null) return null;
    return Knight.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('knights.json', id);
  }

  Future<Faction?> getFaction(Knight knight) async {
    if (knight.factionId == null) return null;
    final factionService = FactionService();
    return await factionService.getById(knight.factionId!);
  }

  Future<Weapon?> getWeapon(Knight knight) async {
    if (knight.weaponId == null) return null;
    final weaponService = WeaponService();
    return await weaponService.getById(knight.weaponId!);
  }

  Future<Armor?> getArmor(Knight knight) async {
    if (knight.armorId == null) return null;
    final armorService = ArmorService();
    return await armorService.getById(knight.armorId!);
  }
}

