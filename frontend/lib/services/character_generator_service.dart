import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class CharacterGeneratorService {
  final ApiService apiService;

  CharacterGeneratorService(this.apiService);

  Future<Map<String, dynamic>> checkStatus() async {
    try {
      final response = await apiService.get('character-generator/status');
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Errore nel controllo stato generatore: $e');
    }
  }

  Future<List<String>> getAvailableClasses() async {
    try {
      final response = await apiService.get('character-generator/classes');
      final data = response as Map<String, dynamic>;
      return (data['classes'] as List).map((e) => e as String).toList();
    } catch (e) {
      if (e.toString().contains('Failed host lookup') || e.toString().contains('Connection refused')) {
        throw Exception('Impossibile connettersi al backend. Assicurati che il server sia avviato.');
      }
      if (e.toString().contains('404') || e.toString().contains('Not Found')) {
        throw Exception('Endpoint non trovato. Verifica che il backend sia avviato e che le librerie siano installate.');
      }
      throw Exception('Errore nel recupero classi: $e');
    }
  }

  Future<List<String>> getAvailableRaces() async {
    try {
      final response = await apiService.get('character-generator/races');
      final data = response as Map<String, dynamic>;
      return (data['races'] as List).map((e) => e as String).toList();
    } catch (e) {
      throw Exception('Errore nel recupero razze: $e');
    }
  }

  Future<Map<String, dynamic>> generateCharacter({
    required String name,
    String? className,
    String? raceName,
    int level = 1,
    bool autoSave = false,
  }) async {
    try {
      final baseUrl = apiService.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/character-generator/generate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'class_name': className,
          'race_name': raceName,
          'level': level,
          'auto_save': autoSave,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      throw Exception('Errore nella generazione personaggio: ${response.body}');
    } catch (e) {
      throw Exception('Errore nella generazione personaggio: $e');
    }
  }
}

