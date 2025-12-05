import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'svg_icon_widget.dart';

/// Widget migliorato per selezionare icone SVG reali dalla struttura icons/
/// Organizza le icone per autore e categoria semantica
class SvgIconPickerWidget extends StatefulWidget {
  final String? selectedIconPath;
  final Function(String) onIconSelected;
  final List<String>? suggestedCategories;
  final String? entityType; // weapon, armor, character, etc.

  const SvgIconPickerWidget({
    super.key,
    this.selectedIconPath,
    required this.onIconSelected,
    this.suggestedCategories,
    this.entityType,
  });

  @override
  State<SvgIconPickerWidget> createState() => _SvgIconPickerWidgetState();
}

class _SvgIconPickerWidgetState extends State<SvgIconPickerWidget> {
  String? _selectedAuthor;
  String? _selectedCategory;
  String? _selectedIcon;
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredIcons = [];
  bool _isLoading = false;

  // Autori disponibili (i più comuni)
  static const List<String> _authors = [
    'lorc',
    'delapouite',
    'sbed',
    'skoll',
    'viscious-speed',
    'caro-asercion',
    'darkzaitzev',
  ];

  // Categorie semantiche -> icone comuni
  static const Map<String, List<Map<String, String>>> _categoryIcons = {
    'weapon': [
      {'path': 'lorc/broadsword.svg', 'name': 'Broadsword'},
      {'path': 'lorc/daggers.svg', 'name': 'Daggers'},
      {'path': 'lorc/battle-axe.svg', 'name': 'Battle Axe'},
      {'path': 'lorc/bowman.svg', 'name': 'Bow'},
      {'path': 'lorc/crossed-swords.svg', 'name': 'Crossed Swords'},
      {'path': 'lorc/hammer-drop.svg', 'name': 'Hammer'},
      {'path': 'lorc/spear-head.svg', 'name': 'Spear'},
      {'path': 'lorc/diving-dagger.svg', 'name': 'Dagger'},
      {'path': 'lorc/energy-sword.svg', 'name': 'Energy Sword'},
      {'path': 'lorc/bloody-sword.svg', 'name': 'Bloody Sword'},
      {'path': 'delapouite/crossbow.svg', 'name': 'Crossbow'},
      {'path': 'carl-olsen/crossbow.svg', 'name': 'Crossbow Alt'},
    ],
    'armor': [
      {'path': 'lorc/breastplate.svg', 'name': 'Breastplate'},
      {'path': 'lorc/armor-vest.svg', 'name': 'Armor Vest'},
      {'path': 'lorc/barbute.svg', 'name': 'Helmet'},
      {'path': 'lorc/crested-helmet.svg', 'name': 'Crested Helmet'},
      {'path': 'lorc/boots.svg', 'name': 'Boots'},
      {'path': 'sbed/shield.svg', 'name': 'Shield'},
      {'path': 'lorc/shield-reflect.svg', 'name': 'Shield Reflect'},
      {'path': 'lorc/checked-shield.svg', 'name': 'Checked Shield'},
    ],
    'character': [
      {'path': 'delapouite/character.svg', 'name': 'Character'},
      {'path': 'delapouite/person.svg', 'name': 'Person'},
      {'path': 'delapouite/wizard-face.svg', 'name': 'Wizard'},
      {'path': 'lorc/wizard-staff.svg', 'name': 'Wizard Staff'},
      {'path': 'delapouite/team-idea.svg', 'name': 'Team'},
      {'path': 'delapouite/party-flags.svg', 'name': 'Party'},
    ],
    'item': [
      {'path': 'lorc/crystal-shine.svg', 'name': 'Crystal'},
      {'path': 'lorc/diamond-hard.svg', 'name': 'Diamond'},
      {'path': 'lorc/emerald.svg', 'name': 'Emerald'},
      {'path': 'lorc/crystal-cluster.svg', 'name': 'Crystal Cluster'},
      {'path': 'lorc/potion-ball.svg', 'name': 'Potion'},
      {'path': 'lorc/scroll-unfurled.svg', 'name': 'Scroll'},
      {'path': 'lorc/book-cover.svg', 'name': 'Book'},
      {'path': 'lorc/ring.svg', 'name': 'Ring'},
    ],
    'location': [
      {'path': 'lorc/castle.svg', 'name': 'Castle'},
      {'path': 'delapouite/tower-flag.svg', 'name': 'Tower'},
      {'path': 'lorc/scroll-unfurled.svg', 'name': 'Map'},
      {'path': 'delapouite/house.svg', 'name': 'House'},
      {'path': 'lorc/campfire.svg', 'name': 'Camp'},
    ],
    'monster': [
      {'path': 'lorc/dragon-head.svg', 'name': 'Dragon'},
      {'path': 'faithtoken/dragon-head.svg', 'name': 'Dragon Head'},
      {'path': 'lorc/skull.svg', 'name': 'Skull'},
      {'path': 'lorc/beast-eye.svg', 'name': 'Beast'},
    ],
    'spell': [
      {'path': 'lorc/fireball.svg', 'name': 'Fireball'},
      {'path': 'lorc/fire-breath.svg', 'name': 'Fire Breath'},
      {'path': 'lorc/arcing-bolt.svg', 'name': 'Lightning'},
      {'path': 'lorc/bolt-eye.svg', 'name': 'Bolt'},
      {'path': 'lorc/drop.svg', 'name': 'Water'},
      {'path': 'lorc/crystal-shine.svg', 'name': 'Magic'},
    ],
    'faction': [
      {'path': 'delapouite/tower-flag.svg', 'name': 'Tower Flag'},
      {'path': 'delapouite/flag-objective.svg', 'name': 'Flag'},
      {'path': 'lorc/crown.svg', 'name': 'Crown'},
      {'path': 'lorc/castle.svg', 'name': 'Castle'},
    ],
    'lore': [
      {'path': 'lorc/quill.svg', 'name': 'Quill'},
      {'path': 'lorc/scroll-unfurled.svg', 'name': 'Scroll'},
      {'path': 'lorc/book-cover.svg', 'name': 'Book'},
      {'path': 'lorc/book-aura.svg', 'name': 'Book Aura'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIconPath;
    
    // Determina categoria iniziale
    if (widget.entityType != null && _categoryIcons.containsKey(widget.entityType)) {
      _selectedCategory = widget.entityType;
    } else if (widget.suggestedCategories != null && widget.suggestedCategories!.isNotEmpty) {
      _selectedCategory = widget.suggestedCategories!.first;
    } else {
      _selectedCategory = _categoryIcons.keys.first;
    }
    
    _selectedAuthor = 'lorc'; // Autore predefinito
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

    final categoryIcons = _categoryIcons[_selectedCategory] ?? [];
    final searchTerm = _searchController.text.toLowerCase();

    List<String> filtered = [];
    
    if (searchTerm.isEmpty) {
      // Mostra tutte le icone della categoria
      filtered = categoryIcons.map((icon) => icon['path']!).toList();
    } else {
      // Filtra per ricerca
      filtered = categoryIcons
          .where((icon) {
            final name = icon['name']?.toLowerCase() ?? '';
            final path = icon['path']?.toLowerCase() ?? '';
            return name.contains(searchTerm) || path.contains(searchTerm);
          })
          .map((icon) => icon['path']!)
          .toList();
    }

    // Filtra per autore se selezionato
    if (_selectedAuthor != null && _selectedAuthor!.isNotEmpty) {
      filtered = filtered.where((path) => path.startsWith('$_selectedAuthor/')).toList();
    }

    setState(() {
      _filteredIcons = filtered;
    });
  }

  String _getIconName(String iconPath) {
    final categoryIcons = _categoryIcons[_selectedCategory] ?? [];
    final icon = categoryIcons.firstWhere(
      (icon) => icon['path'] == iconPath,
      orElse: () => {'name': iconPath.split('/').last.replaceAll('.svg', '')},
    );
    return icon['name'] ?? iconPath.split('/').last.replaceAll('.svg', '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preview dell'icona selezionata
        if (_selectedIcon != null && _selectedIcon!.isNotEmpty)
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
                  iconPath: _selectedIcon!,
                  size: 40,
                  color: AppTheme.getAccentGoldFromContext(context),
                  useThemeColor: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Icona selezionata',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        _getIconName(_selectedIcon!),
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
          items: _categoryIcons.keys.map((category) {
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

        // Selezione autore (opzionale)
        DropdownButtonFormField<String>(
          value: _selectedAuthor,
          decoration: const InputDecoration(
            labelText: 'Autore (opzionale)',
            prefixIcon: Icon(Icons.person),
            hintText: 'Tutti gli autori',
          ),
          items: [
            const DropdownMenuItem(value: '', child: Text('Tutti gli autori')),
            ..._authors.map((author) {
              return DropdownMenuItem(
                value: author,
                child: Text(author),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _selectedAuthor = value ?? '';
              _updateFilteredIcons();
            });
          },
        ),
        const SizedBox(height: 16),

        // Campo di ricerca
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Cerca icona',
            prefixIcon: Icon(Icons.search),
            hintText: 'Digita per filtrare...',
          ),
          onChanged: (_) {
            _updateFilteredIcons();
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
                    'Nessuna icona trovata',
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
                    final iconPath = _filteredIcons[index];
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
                              iconPath: iconPath,
                              size: 32,
                              color: isSelected
                                  ? AppTheme.getAccentGoldFromContext(context)
                                  : AppTheme.getTextPrimaryFromContext(context),
                              useThemeColor: false,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getIconName(iconPath),
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

