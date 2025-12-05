import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'svg_icon_widget.dart';

/// Widget per selezionare un'icona SVG da una griglia organizzata per categorie
class IconPickerWidget extends StatefulWidget {
  final String? selectedIconPath;
  final Function(String) onIconSelected;
  final List<String>? suggestedCategories;

  const IconPickerWidget({
    super.key,
    this.selectedIconPath,
    required this.onIconSelected,
    this.suggestedCategories,
  });

  @override
  State<IconPickerWidget> createState() => _IconPickerWidgetState();
}

class _IconPickerWidgetState extends State<IconPickerWidget> {
  String? _selectedCategory;
  String? _selectedIcon;
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredIcons = [];

  // Category mapping -> icon list
  static const Map<String, List<String>> _iconCategories = {
    'entity': [
      'armor', 'weapon', 'magic-item', 'potion', 'scroll', 'ring', 'wand',
      'spellbook', 'book', 'map', 'person', 'party', 'object', 'loot',
      'tool', 'trinket', 'vehicle', 'mount', 'pet', 'summon', 'location',
      'organization', 'archive', 'time', 'world', 'ship'
    ],
    'weapon': [
      'sword', 'axe', 'mace', 'bow', 'crossbow', 'dagger', 'spear', 'staff',
      'whip', 'flail', 'hammer', 'club', 'sling', 'dart', 'javelin', 'lance',
      'rapier', 'scimitar', 'trident', 'warhammer', 'war-pick', 'whip',
      'net', 'blowgun', 'hand-crossbow', 'light-hammer', 'sickle'
    ],
    'class': [
      'artificer', 'barbarian', 'bard', 'cleric', 'druid', 'fighter',
      'monk', 'paladin', 'ranger', 'rogue', 'sorcerer', 'warlock', 'wizard'
    ],
    'spell': [
      'abjuration', 'conjuration', 'divination', 'enchantment', 'evocation',
      'illusion', 'necromancy', 'transmutation', 'cantrip', 'ritual',
      'concentration', 'instant', 'area', 'target', 'self', 'touch', 'range'
    ],
    'ability': [
      'strength', 'dexterity', 'constitution', 'intelligence', 'wisdom', 'charisma'
    ],
    'attribute': [
      'ac', 'bonus', 'penalty', 'range', 'saving-throw', 'skillcheck',
      'vision', 'light', 'terrain', 'attunement', 'test'
    ],
    'damage': [
      'acid', 'bludgeoning', 'cold', 'fire', 'force', 'lightning', 'necrotic',
      'piercing', 'poison', 'psychic', 'radiant', 'slashing', 'thunder',
      'immunity', 'resistance', 'vulnerability'
    ],
    'condition': [
      'blinded', 'charmed', 'deafened', 'exhaustion', 'frightened', 'grappled',
      'incapacitated', 'invisible', 'paralyzed', 'petrified', 'poisoned',
      'prone', 'restrained', 'silenced', 'sleep', 'stunned', 'unconscious'
    ],
    'combat': [
      'action', 'bonus-action', 'reaction', 'melee', 'ranged', 'reach',
      'initiative', 'round', 'target'
    ],
    'game': [
      'campaign', 'character', 'party', 'spell', 'monster', 'combat',
      'explore', 'social', 'rest', 'puzzle', 'trap', 'hazard', 'dm',
      'inspiration', 'lock', 'adventure-book', 'source-book'
    ],
    'location': [
      'castle', 'tower', 'dungeon', 'tavern', 'village', 'forest', 'mountain',
      'camp', 'hut', 'bastion', 'portal'
    ],
    'monster': [
      'aberration', 'beast', 'celestial', 'construct', 'dragon', 'elemental',
      'fae', 'fiend', 'giant', 'humanoid', 'monstrosity', 'ooze', 'plant', 'undead'
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIconPath;
    _selectedCategory = widget.suggestedCategories?.isNotEmpty == true
        ? widget.suggestedCategories!.first
        : _iconCategories.keys.first;
    _updateFilteredIcons();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilteredIcons() {
    if (_selectedCategory == null) {
      _filteredIcons = [];
      return;
    }

    final categoryIcons = _iconCategories[_selectedCategory] ?? [];
    final searchTerm = _searchController.text.toLowerCase();

    if (searchTerm.isEmpty) {
      _filteredIcons = categoryIcons;
    } else {
      _filteredIcons = categoryIcons
          .where((icon) => icon.toLowerCase().contains(searchTerm))
          .toList();
    }
  }

  String _getIconPath(String category, String iconName) {
    return 'assets/icons/icons/$category/$iconName.svg';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preview dell'icona selezionata
        if (_selectedIcon != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppTheme.getSecondaryBackgroundFromContext(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.getAccentGoldFromContext(context),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                SvgIconWidget(
                  assetPath: _selectedIcon!,
                  size: 40,
                  color: AppTheme.getAccentGoldFromContext(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected icon',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        _selectedIcon!.replaceAll('assets/icons/icons/', ''),
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _selectedIcon = null;
                    });
                    widget.onIconSelected('');
                  },
                ),
              ],
            ),
          ),

        // Selezione categoria
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: const InputDecoration(
            labelText: 'Categoria',
            prefixIcon: Icon(Icons.category),
          ),
          items: _iconCategories.keys.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(
                category.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
              _updateFilteredIcons();
            });
          },
        ),
        const SizedBox(height: 16),

        // Campo di ricerca
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search icon',
            prefixIcon: Icon(Icons.search),
            hintText: 'Digita per filtrare...',
          ),
          onChanged: (_) {
            setState(() {
              _updateFilteredIcons();
            });
          },
        ),
        const SizedBox(height: 16),

        // Griglia icone
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppTheme.getSecondaryBackgroundFromContext(context),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                            color: Theme.of(context).brightness == Brightness.light
                                ? AppTheme.lightBorder
                                : AppTheme.darkBorder,
            ),
          ),
          child: _filteredIcons.isEmpty
              ? Center(
                  child: Text(
                    'No icons found',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.getTextSecondaryFromContext(context),
                        ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _filteredIcons.length,
                  itemBuilder: (context, index) {
                    final iconName = _filteredIcons[index];
                    final iconPath = _getIconPath(_selectedCategory!, iconName);
                    final isSelected = _selectedIcon == iconPath;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIcon = iconPath;
                        });
                        widget.onIconSelected(iconPath);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.getAccentGoldFromContext(context).withOpacity(0.2)
                              : AppTheme.getPrimaryBackgroundFromContext(context),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.getAccentGoldFromContext(context)
                                : (Theme.of(context).brightness == Brightness.light
                                    ? AppTheme.lightBorder
                                    : AppTheme.darkBorder),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgIconWidget(
                              assetPath: iconPath,
                              size: 32,
                              color: isSelected
                                  ? AppTheme.getAccentGoldFromContext(context)
                                  : AppTheme.getTextPrimaryFromContext(context),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              iconName,
                              style: TextStyle(
                                fontSize: 9,
                                color: AppTheme.getTextSecondaryFromContext(context),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}



