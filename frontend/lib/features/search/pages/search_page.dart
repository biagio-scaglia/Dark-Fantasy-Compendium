import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/search/search_service.dart';
import '../../../core/accessibility/accessibility_helper.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/svg_icon_widget.dart';
import '../../../data/services/character_service.dart';
import '../../../data/services/campaign_service.dart';
import '../../../data/services/spell_service.dart';
import '../../../data/services/item_service.dart';
import '../../../data/services/knight_service.dart';
import '../../../data/services/weapon_service.dart';
import '../../../data/services/armor_service.dart';
import '../../../data/services/boss_service.dart';
import '../../../data/services/faction_service.dart';
import '../../../data/services/lore_service.dart';
import '../../../data/services/race_service.dart';
import '../../../data/services/class_service.dart';
import '../../../data/services/party_service.dart';
import '../../../data/services/map_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  Map<String, List<Map<String, dynamic>>> _searchResults = {};
  bool _isSearching = false;
  bool _isIndexing = false;

  @override
  void initState() {
    super.initState();
    _indexAllData();
  }

  Future<void> _indexAllData() async {
    setState(() => _isIndexing = true);
    try {
      // Index all entity types
      final characterService = CharacterService();
      final campaignService = CampaignService();
      final spellService = SpellService();
      final itemService = ItemService();
      final knightService = KnightService();
      final weaponService = WeaponService();
      final armorService = ArmorService();
      final bossService = BossService();
      final factionService = FactionService();
      final loreService = LoreService();
      final raceService = RaceService();
      final classService = ClassService();
      final partyService = PartyService();
      final mapService = MapService();

      final characters = await characterService.getAll();
      final campaigns = await campaignService.getAll();
      final spells = await spellService.getAll();
      final items = await itemService.getAll();
      final knights = await knightService.getAll();
      final weapons = await weaponService.getAll();
      final armors = await armorService.getAll();
      final bosses = await bossService.getAll();
      final factions = await factionService.getAll();
      final lores = await loreService.getAll();
      final races = await raceService.getAll();
      final classes = await classService.getAll();
      final parties = await partyService.getAll();
      final maps = await mapService.getAll();

      _searchService.indexCollection('characters', characters.map((c) => c.toJson()).toList());
      _searchService.indexCollection('campaigns', campaigns.map((c) => c.toJson()).toList());
      _searchService.indexCollection('spells', spells.map((s) => s.toJson()).toList());
      _searchService.indexCollection('items', items.map((i) => i.toJson()).toList());
      _searchService.indexCollection('knights', knights.map((k) => k.toJson()).toList());
      _searchService.indexCollection('weapons', weapons.map((w) => w.toJson()).toList());
      _searchService.indexCollection('armors', armors.map((a) => a.toJson()).toList());
      _searchService.indexCollection('bosses', bosses.map((b) => b.toJson()).toList());
      _searchService.indexCollection('factions', factions.map((f) => f.toJson()).toList());
      _searchService.indexCollection('lores', lores.map((l) => l.toJson()).toList());
      _searchService.indexCollection('races', races.map((r) => r.toJson()).toList());
      _searchService.indexCollection('classes', classes.map((c) => c.toJson()).toList());
      _searchService.indexCollection('parties', parties.map((p) => p.toJson()).toList());
      _searchService.indexCollection('maps', maps.map((m) => m.toJson()).toList());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error indexing data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isIndexing = false);
      }
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = {};
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    final results = _searchService.searchAll(query, limit: 10);
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
    AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.selectionClick);
  }

  String _getRouteForEntityType(String entityType, int id) {
    switch (entityType) {
      case 'characters':
        return '/characters/$id';
      case 'campaigns':
        return '/campaigns/$id';
      case 'spells':
        return '/spells';
      case 'items':
        return '/items/$id';
      case 'knights':
        return '/knights/$id';
      case 'weapons':
        return '/weapons/$id';
      case 'armors':
        return '/armors/$id';
      case 'bosses':
        return '/bosses/$id';
      case 'factions':
        return '/factions/$id';
      case 'lores':
        return '/lores/$id';
      case 'races':
        return '/races/$id';
      case 'classes':
        return '/dnd-classes/$id';
      case 'parties':
        return '/parties/$id';
      case 'maps':
        return '/maps/$id';
      default:
        return '/home';
    }
  }

  String _getEntityTypeLabel(String entityType) {
    switch (entityType) {
      case 'characters':
        return 'Characters';
      case 'campaigns':
        return 'Campaigns';
      case 'spells':
        return 'Spells';
      case 'items':
        return 'Items';
      case 'knights':
        return 'Knights';
      case 'weapons':
        return 'Weapons';
      case 'armors':
        return 'Armors';
      case 'bosses':
        return 'Bosses';
      case 'factions':
        return 'Factions';
      case 'lores':
        return 'Lore';
      case 'races':
        return 'Races';
      case 'classes':
        return 'Classes';
      case 'parties':
        return 'Parties';
      case 'maps':
        return 'Maps';
      default:
        return entityType;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: AppTheme.getPrimaryBackgroundFromContext(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradientFromContext(context),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Semantics(
                label: 'Search input field',
                hint: 'Type to search across all data',
                textField: true,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search characters, campaigns, spells...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppTheme.getSecondaryBackgroundFromContext(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.getAccentGoldFromContext(context),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    _performSearch(value);
                  },
                  onSubmitted: _performSearch,
                ),
              ),
            ),
            if (_isIndexing)
              const Padding(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(),
              ),
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                size: 64,
                                color: AppTheme.getAccentGoldFromContext(context),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchController.text.isEmpty
                                    ? 'Start typing to search'
                                    : 'No results found',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppTheme.getTextSecondaryFromContext(context),
                                    ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final entityType = _searchResults.keys.elementAt(index);
                            final results = _searchResults[entityType]!;
                            return _buildEntityTypeSection(entityType, results);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntityTypeSection(String entityType, List<Map<String, dynamic>> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                _getEntityTypeLabel(entityType),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.getAccentGoldFromContext(context),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text('${results.length}'),
                backgroundColor: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
              ),
            ],
          ),
        ),
        ...results.map((item) => _buildResultCard(entityType, item)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildResultCard(String entityType, Map<String, dynamic> item) {
    final id = item['id'] as int?;
    final name = item['name'] as String? ?? item['title'] as String? ?? 'Unknown';
    final description = item['description'] as String? ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppTheme.getSecondaryBackgroundFromContext(context),
      child: ListTile(
        title: Text(name),
        subtitle: description.isNotEmpty
            ? Text(
                description.length > 100 ? '${description.substring(0, 100)}...' : description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.getAccentGoldFromContext(context),
        ),
        onTap: id != null
            ? () {
                AccessibilityHelper.hapticFeedback(type: HapticFeedbackType.lightImpact);
                context.push(_getRouteForEntityType(entityType, id));
              }
            : null,
      ),
    );
  }
}

