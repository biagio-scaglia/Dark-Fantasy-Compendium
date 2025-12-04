import '../models/spell.dart';
import '../models/class_model.dart';
import 'local_json_service.dart';
import 'json_converter.dart';
import 'class_service.dart';

class SpellService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Spell>> getAll() async {
    final data = await _jsonService.loadJson('spells.json');
    final spells = <Spell>[];
    
    // Load classes once for conversion
    final classService = ClassService();
    final allClasses = await classService.getAll();
    final classMap = {for (var c in allClasses) c.name.toLowerCase(): c.id};
    
    for (var json in data) {
      final converted = JsonConverter.convertToNewFormat(json);
      
      // If classes are still strings, convert them to IDs
      if (converted.containsKey('classes') && converted['classes'] is List) {
        final classes = converted['classes'] as List;
        final classIds = <int>[];
        for (var className in classes) {
          if (className is String) {
            final classId = classMap[className.toLowerCase()];
            if (classId != null) {
              classIds.add(classId);
            }
          } else if (className is int) {
            classIds.add(className);
          }
        }
        if (classIds.isNotEmpty) {
          converted['allowed_class_ids'] = classIds;
        }
        converted.remove('classes');
      }
      
      spells.add(Spell.fromJson(converted));
    }
    
    return spells;
  }

  Future<Spell?> getById(int id) async {
    final entity = await _jsonService.getEntity('spells.json', id);
    if (entity == null) return null;
    
    final converted = JsonConverter.convertToNewFormat(entity);
    
    // If classes are still strings, convert them to IDs
    if (converted.containsKey('classes') && converted['classes'] is List) {
      final classService = ClassService();
      final allClasses = await classService.getAll();
      final classMap = {for (var c in allClasses) c.name.toLowerCase(): c.id};
      
      final classes = converted['classes'] as List;
      final classIds = <int>[];
      for (var className in classes) {
        if (className is String) {
          final classId = classMap[className.toLowerCase()];
          if (classId != null) {
            classIds.add(classId);
          }
        } else if (className is int) {
          classIds.add(className);
        }
      }
      if (classIds.isNotEmpty) {
        converted['allowed_class_ids'] = classIds;
      }
      converted.remove('classes');
    }
    
    return Spell.fromJson(converted);
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

