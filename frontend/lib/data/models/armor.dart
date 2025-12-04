class Armor {
  final int id;
  final String name;
  final String? type;
  final int? defenseBonus;
  final int? durability;
  final String? rarity;
  final String? description;
  final String? lore;
  final String? imagePath;
  final String? iconPath;

  Armor({
    required this.id,
    required this.name,
    this.type,
    this.defenseBonus,
    this.durability,
    this.rarity,
    this.description,
    this.lore,
    this.imagePath,
    this.iconPath,
  });

  factory Armor.fromJson(Map<String, dynamic> json) {
    return Armor(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String?,
      defenseBonus: json['defense_bonus'] as int?,
      durability: json['durability'] as int?,
      rarity: json['rarity'] as String?,
      description: json['description'] as String?,
      lore: json['lore'] as String?,
      imagePath: json['image_path'] as String?,
      iconPath: json['icon_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'defense_bonus': defenseBonus,
      'durability': durability,
      'rarity': rarity,
      'description': description,
      'lore': lore,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}

