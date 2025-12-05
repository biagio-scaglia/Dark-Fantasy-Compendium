import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/character_service.dart';
import '../../../services/pdf_export_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/accessibility/accessibility_helper.dart';
import '../../../widgets/svg_icon_widget.dart';

class CharacterDetailPage extends StatefulWidget {
  final int characterId;

  const CharacterDetailPage({super.key, required this.characterId});

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  Map<String, dynamic>? character;
  bool isLoading = true;
  String? error;
  final CharacterService _service = CharacterService();

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  Future<void> _loadCharacter() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final characterData = await _service.getById(widget.characterId);
      if (characterData != null && mounted) {
        // Convert Character to Map for display
        final data = characterData.toJson();
        setState(() {
          character = data;
          isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          error = 'Character not found';
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteCharacter() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Character'),
        content: Text('Are you sure you want to delete ${character?['name'] ?? 'this character'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _service.delete(widget.characterId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Character deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.heavyImpact);
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deletion error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _exportPdf() async {
    try {
      final pdfService = PdfExportService();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Generating PDF...'),
              ],
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }
      
      final pdfFile = await pdfService.exportCharacterPdf(widget.characterId, simple: true);
      
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PDF generated successfully!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Open',
              textColor: Colors.white,
              onPressed: () async {
                try {
                  await pdfService.sharePdf(pdfFile);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error opening PDF: $e')),
                    );
                  }
                }
              },
            ),
          ),
        );
        AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.heavyImpact);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF export error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Character')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null || character == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Character')),
        body: Center(child: Text('Error: ${error ?? "Character not found"}')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(character!['name'] ?? 'Character'),
        actions: [
          Semantics(
            label: 'Edit character',
            hint: 'Tap to edit character',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.lightImpact);
                context.push('/characters/${widget.characterId}/edit');
              },
              tooltip: 'Edit',
            ),
          ),
          Semantics(
            label: 'Delete character',
            hint: 'Tap to delete character',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.mediumImpact);
                _deleteCharacter();
              },
              tooltip: 'Delete',
            ),
          ),
          Semantics(
            label: 'Export character to PDF',
            hint: 'Tap to generate and export PDF',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () {
                AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.mediumImpact);
                _exportPdf();
              },
              tooltip: 'Export PDF',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              character!['name'] ?? '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            if (character!['player_name'] != null)
              Text(
                'Player: ${character!['player_name']}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const SizedBox(height: 24),
            _buildStatsSection(),
            _buildAbilityScoresSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (character!['level'] != null)
              _buildInfoRow(
                iconPath: 'level-end-flag.svg',
                label: 'Level',
                value: '${character!['level']}',
              ),
            if (character!['current_hit_points'] != null && character!['max_hit_points'] != null)
              _buildInfoRow(
                iconPath: 'heart-plus.svg',
                label: 'Hit Points',
                value: '${character!['current_hit_points']}/${character!['max_hit_points']}',
              ),
            if (character!['armor_class'] != null)
              _buildInfoRow(
                iconPath: 'shield.svg',
                label: 'Class Armor',
                value: '${character!['armor_class']}',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbilityScoresSection() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ability Scores',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildAbilityRow('Forza', character!['strength']),
            _buildAbilityRow('Destrezza', character!['dexterity']),
            _buildAbilityRow('Costituzione', character!['constitution']),
            _buildAbilityRow('Intelligenza', character!['intelligence']),
            _buildAbilityRow('Saggezza', character!['wisdom']),
            _buildAbilityRow('Carisma', character!['charisma']),
          ],
        ),
      ),
    );
  }

  Widget _buildAbilityRow(String name, int? value) {
    final modifier = value != null ? ((value - 10) / 2).floor() : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: Theme.of(context).textTheme.bodyLarge),
          Row(
            children: [
              Text('$value', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  modifier >= 0 ? '+$modifier' : '$modifier',
                  style: TextStyle(color: AppTheme.getAccentGoldFromContext(context)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required String iconPath, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SvgIconWidget(
            iconPath: iconPath,
            size: 20,
            color: AppTheme.getAccentGoldFromContext(context),
            useThemeColor: false,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextSecondaryFromContext(context),
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


