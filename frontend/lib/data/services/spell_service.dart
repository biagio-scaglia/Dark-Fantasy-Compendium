import '../models/spell.dart';
import '../models/class_model.dart';
import 'local_json_service.dart';
import 'json_converter.dart';
import 'class_service.dart';

class SpellService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Spell>> getAll() async {
    final data = await _jsonService.loadJson('spells.json');
    return data.map((json) => Spell.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Spell?> getById(int id) async {
    final entity = await _jsonService.getEntity('spells.json', id);
    if (entity == null) return null;
    return Spell.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Spell> create(Spell spell) async {
    final json = spell.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('spells.json', json);
    return Spell.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Spell?> update(Spell spell) async {
    final json = spell.toJson();
    final updated = await _jsonService.updateEntity('spells.json', spell.id, json);
    if (updated == null) return null;
    return Spell.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('spells.json', id);
  }

  Future<List<ClassModel>> getAllowedClasses(Spell spell) async {
    if (spell.allowedClassIds == null || spell.allowedClassIds!.isEmpty) return [];
    final classService = ClassService();
    final allClasses = await classService.getAll();
    return allClasses.where((c) => spell.allowedClassIds!.contains(c.id)).toList();
  }
}

