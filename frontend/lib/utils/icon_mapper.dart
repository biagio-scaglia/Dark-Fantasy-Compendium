/// Utility to map entity and object types to their appropriate SVG icons
class IconMapper {
  IconMapper._();

  // Base path for icons
  static const String _basePath = 'assets/icons';

  // Mapping for armor types
  static String? getArmorIconPath(String? type) {
    if (type == null) return '$_basePath/shield.svg';
    
    final normalizedType = type.toLowerCase();
    
    // Specific mapping for armor type
    switch (normalizedType) {
      case 'chest':
      case 'armor':
      case 'breastplate':
        return '$_basePath/breastplate.svg';
      case 'helmet':
      case 'helm':
      case 'head':
        return '$_basePath/barbute.svg';
      case 'legs':
      case 'leggings':
      case 'greaves':
        return '$_basePath/armored-pants.svg';
      case 'boots':
      case 'feet':
        return '$_basePath/barefoot.svg';
      case 'gloves':
      case 'gauntlets':
      case 'hands':
        return '$_basePath/arm-bandage.svg';
      case 'shield':
        return '$_basePath/shield.svg';
      default:
        return '$_basePath/shield.svg';
    }
  }

  // Mapping for weapon types
  static String? getWeaponIconPath(String? type) {
    if (type == null) return '$_basePath/sword.svg';
    
    final normalizedType = type.toLowerCase();
    
    // Mapping for weapon type
    switch (normalizedType) {
      case 'sword':
      case 'longsword':
      case 'shortsword':
        return '$_basePath/broadsword.svg';
      case 'axe':
      case 'battleaxe':
      case 'handaxe':
        return '$_basePath/battle-axe.svg';
      case 'mace':
      case 'club':
      case 'hammer':
        return '$_basePath/hammer-drop.svg';
      case 'bow':
      case 'longbow':
      case 'shortbow':
        return '$_basePath/archery-target.svg';
      case 'crossbow':
        return '$_basePath/crossbow.svg';
      case 'dagger':
      case 'knife':
        return '$_basePath/daggers.svg';
      case 'spear':
      case 'lance':
        return '$_basePath/spear.svg';
      case 'staff':
      case 'wand':
        return '$_basePath/wizard-staff.svg';
      case 'whip':
        return '$_basePath/whip.svg';
      default:
        return '$_basePath/sword.svg';
    }
  }

  // Mapping for D&D classes
  static String? getClassIconPath(String? className) {
    if (className == null) return '$_basePath/barbarian.svg';
    
    final normalizedName = className.toLowerCase().replaceAll(' ', '-');
    
    // Map class names to icon files that actually exist
    switch (normalizedName) {
      case 'barbarian':
        return '$_basePath/barbarian.svg';
      case 'bard':
        return '$_basePath/bagpipes.svg';
      case 'cleric':
        return '$_basePath/angel-wings.svg';
      case 'druid':
        return '$_basePath/berry-bush.svg';
      case 'fighter':
        return '$_basePath/battle-axe.svg';
      case 'monk':
        return '$_basePath/bo.svg';
      case 'paladin':
        return '$_basePath/shield.svg';
      case 'ranger':
        return '$_basePath/archery-target.svg';
      case 'rogue':
        return '$_basePath/rogue.svg';
      case 'sorcerer':
        return '$_basePath/crystal-shine.svg';
      case 'warlock':
        return '$_basePath/warlock-hood.svg';
      case 'wizard':
        return '$_basePath/wizard-staff.svg';
      default:
        // Try to find icon with class name
        return '$_basePath/$normalizedName.svg';
    }
  }

  // Mapping for generic entities
  static String? getEntityIconPath(String? entityType) {
    if (entityType == null) return '$_basePath/info.svg';
    
    final normalizedType = entityType.toLowerCase();
    
    switch (normalizedType) {
      case 'armor':
        return '$_basePath/shield.svg';
      case 'weapon':
        return '$_basePath/sword.svg';
      case 'item':
      case 'magic-item':
        return '$_basePath/star-swirl.svg';
      case 'potion':
        return '$_basePath/potion.svg';
      case 'scroll':
        return '$_basePath/scroll-unfurled.svg';
      case 'ring':
        return '$_basePath/big-diamond-ring.svg';
      case 'wand':
        return '$_basePath/wizard-staff.svg';
      case 'book':
      case 'spellbook':
        return '$_basePath/book-cover.svg';
      case 'map':
        return '$_basePath/map.svg';
      case 'character':
      case 'person':
        return '$_basePath/character.svg';
      case 'party':
        return '$_basePath/team-idea.svg';
      case 'campaign':
        return '$_basePath/house.svg';
      case 'spell':
        return '$_basePath/arcing-bolt.svg';
      default:
        return '$_basePath/info.svg';
    }
  }

  // Mapping for attributes/stats
  static String? getAttributeIconPath(String? attribute) {
    if (attribute == null) return null;
    
    final normalizedAttr = attribute.toLowerCase().replaceAll(' ', '-');
    // Try to find icon with attribute name directly
    return '$_basePath/$normalizedAttr.svg';
  }

  // Mapping for abilities
  static String? getAbilityIconPath(String? abilityName) {
    if (abilityName == null) return null;
    
    final normalizedName = abilityName.toLowerCase().replaceAll(' ', '-');
    // Try to find icon with ability name directly
    return '$_basePath/$normalizedName.svg';
  }

  // Helper to get icon from custom path or automatic mapping
  static String? getIconPath({
    String? customPath,
    String? type,
    String? entityType,
    String? className,
  }) {
    // If there's a custom path, use it
    if (customPath != null && customPath.isNotEmpty) {
      // Se è solo il nome del file, aggiungi il path completo
      if (!customPath.contains('/')) {
        return '$_basePath/$customPath';
      }
      // If it doesn't start with 'assets/', add it
      if (!customPath.startsWith('assets/')) {
        return 'assets/$customPath';
      }
      return customPath;
    }

    // Otherwise use automatic mapping
    if (className != null) {
      return getClassIconPath(className);
    }
    
    if (entityType != null) {
      return getEntityIconPath(entityType);
    }
    
    if (type != null) {
      // Prova prima come tipo di arma, poi come tipo di armor
      final weaponPath = getWeaponIconPath(type);
      if (weaponPath != null && weaponPath.contains('weapon')) {
        return weaponPath;
      }
      return getArmorIconPath(type);
    }

    return '$_basePath/info.svg';
  }
}


