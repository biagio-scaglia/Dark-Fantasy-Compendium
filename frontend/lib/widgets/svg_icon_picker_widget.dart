import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';
import 'svg_icon_widget.dart';

/// Simplified widget to select SVG icons
/// Shows all available icons with search functionality
class SvgIconPickerWidget extends StatefulWidget {
  final String? selectedIconPath;
  final Function(String) onIconSelected;

  const SvgIconPickerWidget({
    super.key,
    this.selectedIconPath,
    required this.onIconSelected,
  });

  @override
  State<SvgIconPickerWidget> createState() => _SvgIconPickerWidgetState();
}

class _SvgIconPickerWidgetState extends State<SvgIconPickerWidget> {
  String? _selectedIcon;
  final TextEditingController _searchController = TextEditingController();
  List<String> _allIcons = [];
  List<String> _filteredIcons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIconPath;
    _loadIcons();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadIcons() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all icons from AssetManifest
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      
      // Parse JSON manifest
      final manifestJson = json.decode(manifestContent) as Map<String, dynamic>;
      final iconPaths = <String>[];
      
      // Extract all assets/icons/*.svg paths
      for (final key in manifestJson.keys) {
        if (key.startsWith('assets/icons/') && key.endsWith('.svg')) {
          // Remove 'assets/icons/' prefix to get just the filename
          final iconName = key.substring('assets/icons/'.length);
          iconPaths.add(iconName);
        }
      }

      setState(() {
        _allIcons = iconPaths..sort();
        _filteredIcons = _allIcons;
        _isLoading = false;
      });
      
      _updateFilteredIcons();
    } catch (e) {
      // Fallback: try to parse as string if JSON parsing fails
      try {
        final manifestContent = await rootBundle.loadString('AssetManifest.json');
        final iconPaths = <String>[];
        
        // Extract using regex
        final regex = RegExp(r'"assets/icons/([^"]+\.svg)"');
        final matches = regex.allMatches(manifestContent);
        
        for (final match in matches) {
          final iconName = match.group(1);
          if (iconName != null) {
            iconPaths.add(iconName);
          }
        }
        
        setState(() {
          _allIcons = iconPaths..sort();
          _filteredIcons = _allIcons;
          _isLoading = false;
        });
        _updateFilteredIcons();
      } catch (e2) {
        // Final fallback: use common icons
        setState(() {
          _allIcons = _getCommonIcons()..sort();
          _filteredIcons = _allIcons;
          _isLoading = false;
        });
        _updateFilteredIcons();
      }
    }
  }

  List<String> _getCommonIcons() {
    // Return a list of common icon names
    return [
      'house.svg', 'book-cover.svg', 'character.svg', 'team-idea.svg',
      'info.svg', 'flag-objective.svg', 'calendar.svg', 'shield.svg',
      'sword.svg', 'battle-axe.svg', 'dagger.svg', 'crossbow.svg',
      'wizard-staff.svg', 'crown.svg', 'scroll-unfurled.svg', 'quill.svg',
      'barbarian.svg', 'rogue.svg', 'warlock-hood.svg', 'wizard-staff.svg',
      'breastplate.svg', 'barbute.svg', 'archery-target.svg', 'bagpipes.svg',
      'angel-wings.svg', 'berry-bush.svg', 'bo.svg', 'crystal-shine.svg',
      'arcing-bolt.svg', 'dragon-head.svg', 'skull.svg', 'potion.svg',
      'ring.svg', 'map.svg', 'campfire.svg', 'castle.svg',
    ];
  }

  void _updateFilteredIcons() {
    final searchTerm = _searchController.text.toLowerCase();
    
    if (searchTerm.isEmpty) {
      setState(() {
        _filteredIcons = _allIcons;
      });
    } else {
      setState(() {
        _filteredIcons = _allIcons
            .where((icon) => icon.toLowerCase().contains(searchTerm))
            .toList();
      });
    }
  }

  String _getIconDisplayName(String iconPath) {
    // Convert filename to display name
    return iconPath
        .replaceAll('.svg', '')
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word.isEmpty 
            ? '' 
            : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Selected icon',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        _getIconDisplayName(_selectedIcon!),
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

        // Campo di ricerca
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search icon',
            hintText: 'Type to filter icons...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (_) {
            _updateFilteredIcons();
          },
        ),
        const SizedBox(height: 16),

        // Griglia icone - usa Flexible invece di Expanded
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 200,
              maxHeight: 400,
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
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
                                    mainAxisSize: MainAxisSize.min,
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
                                        _getIconDisplayName(iconPath),
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
          ),
        ),
      ],
    );
  }
}
