import '../models/boss.dart';
import '../models/item.dart';
import 'local_json_service.dart';
import 'json_converter.dart';
import 'item_service.dart';

class BossService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Boss>> getAll() async {
    final data = await _jsonService.loadJson('bosses.json');
    return data.map((json) => Boss.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Boss?> getById(int id) async {
    final entity = await _jsonService.getEntity('bosses.json', id);
    if (entity == null) return null;
    return Boss.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Boss> create(Boss boss) async {
    final json = boss.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('bosses.json', json);
    return Boss.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Boss?> update(Boss boss) async {
    final json = boss.toJson();
    final updated = await _jsonService.updateEntity('bosses.json', boss.id, json);
    if (updated == null) return null;
    return Boss.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('bosses.json', id);
  }

  Future<List<Item>> getRewards(Boss boss) async {
    if (boss.rewardIds == null || boss.rewardIds!.isEmpty) return [];
    final itemService = ItemService();
    final allItems = await itemService.getAll();
    return allItems.where((i) => boss.rewardIds!.contains(i.id)).toList();
  }
}


