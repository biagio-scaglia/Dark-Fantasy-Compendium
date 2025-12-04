import '../models/character.dart';
import '../models/class_model.dart';
import '../models/race.dart';
import 'local_json_service.dart';
import 'json_converter.dart';
import 'class_service.dart';
import 'race_service.dart';

class CharacterService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Character>> getAll() async {
    final data = await _jsonService.loadJson('characters.json');
    return data.map((json) => Character.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Character?> getById(int id) async {
    final entity = await _jsonService.getEntity('characters.json', id);
    if (entity == null) return null;
    return Character.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Character> create(Character character) async {
    final json = character.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('characters.json', json);
    return Character.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Character?> update(Character character) async {
    final json = character.toJson();
    final updated = await _jsonService.updateEntity('characters.json', character.id, json);
    if (updated == null) return null;
    return Character.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('characters.json', id);
  }

  Future<ClassModel?> getClass(int? classId) async {
    if (classId == null) return null;
    final classService = ClassService();
    return await classService.getById(classId);
  }

  Future<Race?> getRace(int? raceId) async {
    if (raceId == null) return null;
    final raceService = RaceService();
    return await raceService.getById(raceId);
  }
}

