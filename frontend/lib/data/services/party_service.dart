import '../models/party.dart';
import '../models/character.dart';
import '../models/campaign.dart';
import 'local_json_service.dart';
import 'json_converter.dart';
import 'character_service.dart';
import 'campaign_service.dart';

class PartyService {
  final LocalJsonService _jsonService = LocalJsonService();

  Future<List<Party>> getAll() async {
    final data = await _jsonService.loadJson('parties.json');
    return data.map((json) => Party.fromJson(JsonConverter.convertToNewFormat(json))).toList();
  }

  Future<Party?> getById(int id) async {
    final entity = await _jsonService.getEntity('parties.json', id);
    if (entity == null) return null;
    return Party.fromJson(JsonConverter.convertToNewFormat(entity));
  }

  Future<Party> create(Party party) async {
    final json = party.toJson();
    json.remove('id');
    final created = await _jsonService.createEntity('parties.json', json);
    return Party.fromJson(JsonConverter.convertToNewFormat(created));
  }

  Future<Party?> update(Party party) async {
    final json = party.toJson();
    final updated = await _jsonService.updateEntity('parties.json', party.id, json);
    if (updated == null) return null;
    return Party.fromJson(JsonConverter.convertToNewFormat(updated));
  }

  Future<bool> delete(int id) async {
    return await _jsonService.deleteEntity('parties.json', id);
  }

  Future<List<Character>> getMembers(Party party) async {
    if (party.memberIds == null || party.memberIds!.isEmpty) return [];
    final characterService = CharacterService();
    final allCharacters = await characterService.getAll();
    return allCharacters.where((c) => party.memberIds!.contains(c.id)).toList();
  }

  Future<Campaign?> getCampaign(Party party) async {
    if (party.campaignId == null) return null;
    final campaignService = CampaignService();
    return await campaignService.getById(party.campaignId!);
  }
}

