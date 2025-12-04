import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class DiceService {
  final ApiService apiService;

  DiceService(this.apiService);

  Future<Map<String, dynamic>> checkStatus() async {
    try {
      final response = await apiService.get('dice/status');
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Errore nel controllo stato dadi: $e');
    }
  }

  Future<DiceRollResult> rollDice(String notation) async {
    try {
      final baseUrl = apiService.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/dice/roll'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'notation': notation}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return DiceRollResult.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint non trovato. Verifica che il backend sia avviato e che le librerie siano installate.');
      } else if (response.statusCode == 503) {
        final errorData = json.decode(response.body);
        throw Exception('Servizio non disponibile: ${errorData['detail'] ?? 'Installa dndice: pip install dndice'}');
      }
      final errorBody = response.body;
      throw Exception('Errore nel tiro dei dadi (${response.statusCode}): $errorBody');
    } catch (e) {
      if (e.toString().contains('Failed host lookup') || e.toString().contains('Connection refused')) {
        throw Exception('Impossibile connettersi al backend. Assicurati che il server sia avviato su http://localhost:8000');
      }
      throw Exception('Errore nel tiro dei dadi: $e');
    }
  }

  Future<DiceRollResult> rollAbilityCheck(int modifier) async {
    try {
      final baseUrl = apiService.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/dice/ability-check'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'modifier': modifier}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return DiceRollResult.fromJson(data);
      }
      throw Exception('Errore nella prova di caratteristica: ${response.body}');
    } catch (e) {
      throw Exception('Errore nella prova di caratteristica: $e');
    }
  }

  Future<DiceRollResult> rollSavingThrow(int modifier) async {
    try {
      final baseUrl = apiService.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/dice/saving-throw'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'modifier': modifier}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return DiceRollResult.fromJson(data);
      }
      throw Exception('Errore nel tiro salvezza: ${response.body}');
    } catch (e) {
      throw Exception('Errore nel tiro salvezza: $e');
    }
  }

  Future<DiceRollResult> rollDamage(String diceNotation, int modifier) async {
    try {
      final baseUrl = apiService.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/dice/damage'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'dice_notation': diceNotation,
          'modifier': modifier,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return DiceRollResult.fromJson(data);
      }
      throw Exception('Errore nel tiro di danno: ${response.body}');
    } catch (e) {
      throw Exception('Errore nel tiro di danno: $e');
    }
  }

  Future<List<DiceRollResult>> rollMultiple(List<String> notations) async {
    try {
      final baseUrl = apiService.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/dice/roll/multiple'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'notations': notations}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => DiceRollResult.fromJson(item as Map<String, dynamic>)).toList();
      }
      throw Exception('Errore nei tiri multipli: ${response.body}');
    } catch (e) {
      throw Exception('Errore nei tiri multipli: $e');
    }
  }
}

class DiceRollResult {
  final String notation;
  final int result;
  final int total;
  final List<int> rolls;
  final String? details;

  DiceRollResult({
    required this.notation,
    required this.result,
    required this.total,
    required this.rolls,
    this.details,
  });

  factory DiceRollResult.fromJson(Map<String, dynamic> json) {
    return DiceRollResult(
      notation: json['notation'] as String,
      result: json['result'] as int,
      total: json['total'] as int,
      rolls: (json['rolls'] as List).map((e) => e as int).toList(),
      details: json['details'] as String?,
    );
  }
}

