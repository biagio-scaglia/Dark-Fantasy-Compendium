import '../models/class_model.dart';
import 'local_json_service.dart';
import 'json_converter.dart';

class ClassService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<ClassModel>> getAll() async {
    final data = await _jsonService.loadJson('classes.json');
    return data.map((json) => ClassModel.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<ClassModel?> getById(int id) async {
    final entity = await _jsonService.getEntity('classes.json', id);
    if (entity == null) return null;
    return ClassModel.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<ClassModel> create(ClassModel classModel) async {
    final json = classModel.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('classes.json', json);
    return ClassModel.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<ClassModel?> update(ClassModel classModel) async {
    final json = classModel.toJson();
    final updated = await _jsonService.updateEntity('classes.json', classModel.id, json);
    if (updated == null) return null;
    return ClassModel.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('classes.json', id);
  }
}


