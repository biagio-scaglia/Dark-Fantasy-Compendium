/// Utility per mappare tipi di entità e oggetti alle loro icone SVG appropriate
class IconMapper {
  IconMapper._();

  // Base path per le icone
  static const String _basePath = 'icons';

  // Mappatura per tipi di armatura
  static String? getArmorIconPath(String? type) {
    if (type == null) return '$_basePath/entity/armor.svg';
    
    final normalizedType = type.toLowerCase();
    
    // Mappatura specifica per tipo di armatura
    switch (normalizedType) {
      case 'chest':
      case 'armor':
      case 'breastplate':
        return '$_basePath/entity/armor.svg';
      case 'helmet':
      case 'helm':
      case 'head':
        return '$_basePath/entity/armor.svg'; // Usa armor generico per ora
      case 'legs':
      case 'leggings':
      case 'greaves':
        return '$_basePath/entity/armor.svg';
      case 'boots':
      case 'feet':
        return '$_basePath/entity/armor.svg';
      case 'gloves':
      case 'gauntlets':
      case 'hands':
        return '$_basePath/entity/armor.svg';
      case 'shield':
        return '$_basePath/entity/armor.svg';
      default:
        return '$_basePath/entity/armor.svg';
    }
  }

  // Mappatura per tipi di armi
  static String? getWeaponIconPath(String? type) {
    if (type == null) return '$_basePath/entity/weapon.svg';
    
    final normalizedType = type.toLowerCase();
    
    // Mappatura per tipo di arma
    switch (normalizedType) {
      case 'sword':
      case 'longsword':
      case 'shortsword':
        return '$_basePath/weapon/sword.svg';
      case 'axe':
      case 'battleaxe':
      case 'handaxe':
        return '$_basePath/weapon/axe.svg';
      case 'mace':
      case 'club':
      case 'hammer':
        return '$_basePath/weapon/mace.svg';
      case 'bow':
      case 'longbow':
      case 'shortbow':
        return '$_basePath/weapon/bow.svg';
      case 'crossbow':
        return '$_basePath/weapon/crossbow.svg';
      case 'dagger':
      case 'knife':
        return '$_basePath/weapon/dagger.svg';
      case 'spear':
      case 'lance':
        return '$_basePath/weapon/spear.svg';
      case 'staff':
      case 'wand':
        return '$_basePath/weapon/staff.svg';
      case 'whip':
        return '$_basePath/weapon/whip.svg';
      default:
        return '$_basePath/entity/weapon.svg';
    }
  }

  // Mappatura per classi D&D
  static String? getClassIconPath(String? className) {
    if (className == null) return '$_basePath/class/fighter.svg';
    
    final normalizedName = className.toLowerCase().replaceAll(' ', '-');
    return '$_basePath/class/$normalizedName.svg';
  }

  // Mappatura per entità generiche
  static String? getEntityIconPath(String? entityType) {
    if (entityType == null) return '$_basePath/entity/object.svg';
    
    final normalizedType = entityType.toLowerCase();
    
    switch (normalizedType) {
      case 'armor':
        return '$_basePath/entity/armor.svg';
      case 'weapon':
        return '$_basePath/entity/weapon.svg';
      case 'item':
      case 'magic-item':
        return '$_basePath/entity/magic-item.svg';
      case 'potion':
        return '$_basePath/entity/potion.svg';
      case 'scroll':
        return '$_basePath/entity/scroll.svg';
      case 'ring':
        return '$_basePath/entity/ring.svg';
      case 'wand':
        return '$_basePath/entity/wand.svg';
      case 'book':
      case 'spellbook':
        return '$_basePath/entity/spellbook.svg';
      case 'map':
        return '$_basePath/entity/map.svg';
      case 'character':
      case 'person':
        return '$_basePath/entity/person.svg';
      case 'party':
        return '$_basePath/game/party.svg';
      case 'campaign':
        return '$_basePath/game/campaign.svg';
      case 'spell':
        return '$_basePath/game/spell.svg';
      default:
        return '$_basePath/entity/object.svg';
    }
  }

  // Mappatura per attributi/statistiche
  static String? getAttributeIconPath(String? attribute) {
    if (attribute == null) return null;
    
    final normalizedAttr = attribute.toLowerCase().replaceAll(' ', '-');
    return '$_basePath/attribute/$normalizedAttr.svg';
  }

  // Mappatura per abilità
  static String? getAbilityIconPath(String? abilityName) {
    if (abilityName == null) return null;
    
    final normalizedName = abilityName.toLowerCase().replaceAll(' ', '-');
    return '$_basePath/ability/$normalizedName.svg';
  }

  // Helper per ottenere icona da path personalizzato o mappatura automatica
  static String? getIconPath({
    String? customPath,
    String? type,
    String? entityType,
    String? className,
  }) {
    // Se c'è un path personalizzato, usalo
    if (customPath != null && customPath.isNotEmpty) {
      // Se non inizia con 'assets/', aggiungilo
      if (!customPath.startsWith('assets/')) {
        return 'assets/$customPath';
      }
      return customPath;
    }

    // Altrimenti usa la mappatura automatica
    if (className != null) {
      return getClassIconPath(className);
    }
    
    if (entityType != null) {
      return getEntityIconPath(entityType);
    }
    
    if (type != null) {
      // Prova prima come tipo di arma, poi come tipo di armatura
      final weaponPath = getWeaponIconPath(type);
      if (weaponPath != null && weaponPath.contains('weapon')) {
        return weaponPath;
      }
      return getArmorIconPath(type);
    }

    return '$_basePath/entity/object.svg';
  }
}

