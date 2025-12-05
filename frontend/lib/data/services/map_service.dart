import '../models/map_model.dart';
import '../models/campaign.dart';
import 'local_json_service.dart';
import 'json_converter.dart';
import 'campaign_service.dart';

class MapService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<MapModel>> getAll() async {
    final data = await _jsonService.loadJson('maps.json');
    return data.map((json) => MapModel.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<MapModel?> getById(int id) async {
    final entity = await _jsonService.getEntity('maps.json', id);
    if (entity == null) return null;
    return MapModel.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<MapModel> create(MapModel map) async {
    final json = map.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('maps.json', json);
    return MapModel.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<MapModel?> update(MapModel map) async {
    final json = map.toJson();
    final updated = await _jsonService.updateEntity('maps.json', map.id, json);
    if (updated == null) return null;
    return MapModel.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('maps.json', id);
  }

  Future<Campaign?> getCampaign(MapModel map) async {
    if (map.campaignId == null) return null;
    final campaignService = CampaignService();
    return await campaignService.getById(map.campaignId!);
  }

  Future<List<MapModel>> getByCampaignId(int campaignId) async {
    final all = await getAll();
    return all.where((m) => m.campaignId == campaignId).toList();
  }
}


