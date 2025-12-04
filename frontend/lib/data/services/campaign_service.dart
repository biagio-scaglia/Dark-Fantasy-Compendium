import '../models/campaign.dart';
import '../models/character.dart';
import 'local_json_service.dart';
import 'json_converter.dart';
import 'character_service.dart';

class CampaignService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Campaign>> getAll() async {
    final data = await _jsonService.loadJson('campaigns.json');
    return data.map((json) => Campaign.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Campaign?> getById(int id) async {
    final entity = await _jsonService.getEntity('campaigns.json', id);
    if (entity == null) return null;
    return Campaign.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Campaign> create(Campaign campaign) async {
    final json = campaign.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('campaigns.json', json);
    return Campaign.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Campaign?> update(Campaign campaign) async {
    final json = campaign.toJson();
    final updated = await _jsonService.updateEntity('campaigns.json', campaign.id, json);
    if (updated == null) return null;
    return Campaign.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('campaigns.json', id);
  }

  Future<List<Character>> getCharacters(Campaign campaign) async {
    if (campaign.characterIds == null || campaign.characterIds!.isEmpty) return [];
    final characterService = CharacterService();
    final allCharacters = await characterService.getAll();
    return allCharacters.where((c) => campaign.characterIds!.contains(c.id)).toList();
  }
}

