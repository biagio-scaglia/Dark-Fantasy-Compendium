import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../data/services/character_service.dart';
import '../utils/logger.dart';

/// Service for PDF export (offline, using isolates)
class PdfExportService {
  static final PdfExportService _instance = PdfExportService._internal();
  factory PdfExportService() => _instance;
  PdfExportService._internal();

  final CharacterService _characterService = CharacterService();

  /// Export character as PDF
  Future<File> exportCharacterPdf(int characterId, {bool simple = true}) async {
    try {
      final character = await _characterService.getById(characterId);
      if (character == null) {
        throw Exception('Character not found');
      }

      // Generate PDF (pdf.save() is async, so we can't use compute isolate)
      final pdfBytes = await _generateCharacterPdf(
        character.toJson(),
        simple,
      );

      // Save PDF
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final directory = await getApplicationDocumentsDirectory();
      final filename = 'character_${character.name}_$timestamp.pdf';
      final file = File('${directory.path}/$filename');
      await file.writeAsBytes(pdfBytes);

      AppLogger.info('PDF exported: ${file.path}');
      return file;
    } catch (e, stack) {
      AppLogger.error('Failed to export character PDF', e, stack);
      rethrow;
    }
  }

  /// Share PDF via share dialog
  Future<void> sharePdf(File pdfFile) async {
    try {
      await Printing.layoutPdf(
        onLayout: (format) async => await pdfFile.readAsBytes(),
      );
    } catch (e) {
      AppLogger.error('Failed to share PDF', e);
      rethrow;
    }
  }

  /// Save and open PDF
  Future<void> saveAndOpenPdf(Uint8List bytes, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } catch (e) {
      AppLogger.error('Error saving/opening PDF', e);
      throw Exception('Error saving/opening PDF: $e');
    }
  }
}

/// Generate character PDF
Future<Uint8List> _generateCharacterPdf(
  Map<String, dynamic> characterJson,
  bool simple,
) async {
  try {
    final pdf = pw.Document();

    if (simple) {
      pdf.addPage(_buildSimpleCharacterPage(characterJson));
    } else {
      pdf.addPage(_buildDetailedCharacterPage(characterJson));
    }

    return await pdf.save();
  } catch (e) {
    throw Exception('PDF generation failed: $e');
  }
}

/// Build simple character page
pw.Page _buildSimpleCharacterPage(Map<String, dynamic> character) {
  return pw.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pw.Context context) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(40),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Text(
                character['name'] ?? 'Unknown Character',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            _buildSection('Basic Information', [
              _buildInfoRow('Level', character['level']?.toString() ?? 'N/A'),
              _buildInfoRow('Class', character['class_id']?.toString() ?? 'N/A'),
              _buildInfoRow('Race', character['race_id']?.toString() ?? 'N/A'),
            ]),
            pw.SizedBox(height: 20),
            if (character['stats'] != null)
              _buildStatsSection(character['stats'] as Map<String, dynamic>),
          ],
        ),
      );
    },
  );
}

/// Build detailed character page
pw.Page _buildDetailedCharacterPage(Map<String, dynamic> character) {
  return pw.Page(
    pageFormat: PdfPageFormat.a4,
    build: (pw.Context context) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(40),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Text(
                character['name'] ?? 'Unknown Character',
                style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 30),
            _buildSection('Character Information', [
              _buildInfoRow('Level', character['level']?.toString() ?? 'N/A'),
              _buildInfoRow('Class ID', character['class_id']?.toString() ?? 'N/A'),
              _buildInfoRow('Race ID', character['race_id']?.toString() ?? 'N/A'),
            ]),
            pw.SizedBox(height: 20),
            if (character['stats'] != null)
              _buildStatsSection(character['stats'] as Map<String, dynamic>),
            pw.SizedBox(height: 20),
            if (character['description'] != null && character['description'].toString().isNotEmpty)
              _buildSection('Description', [
                pw.Text(character['description'].toString()),
              ]),
          ],
        ),
      );
    },
  );
}

/// Build section
pw.Widget _buildSection(String title, List<pw.Widget> children) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        title,
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 10),
      ...children,
    ],
  );
}

/// Build info row
pw.Widget _buildInfoRow(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Row(
      children: [
        pw.Text(
          '$label: ',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(value),
      ],
    ),
  );
}

/// Build stats section
pw.Widget _buildStatsSection(Map<String, dynamic> stats) {
  return _buildSection('Statistics', [
    if (stats['strength'] != null)
      _buildInfoRow('Strength', stats['strength'].toString()),
    if (stats['dexterity'] != null)
      _buildInfoRow('Dexterity', stats['dexterity'].toString()),
    if (stats['constitution'] != null)
      _buildInfoRow('Constitution', stats['constitution'].toString()),
    if (stats['intelligence'] != null)
      _buildInfoRow('Intelligence', stats['intelligence'].toString()),
    if (stats['wisdom'] != null)
      _buildInfoRow('Wisdom', stats['wisdom'].toString()),
    if (stats['charisma'] != null)
      _buildInfoRow('Charisma', stats['charisma'].toString()),
    if (stats['hit_points'] != null)
      _buildInfoRow('Hit Points', stats['hit_points'].toString()),
    if (stats['armor_class'] != null)
      _buildInfoRow('Armor Class', stats['armor_class'].toString()),
  ]);
}


