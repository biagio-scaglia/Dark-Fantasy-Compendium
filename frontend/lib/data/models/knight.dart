class Knight {
  final int id;
  final String name;
  final String? title;
  final int? factionId;
  final int level;
  final int health;
  final int maxHealth;
  final int attack;
  final int defense;
  final int? weaponId;
  final int? armorId;
  final String? description;
  final String? lore;
  final String? imagePath;
  final String? iconPath;

  Knight({
    required this.id,
    required this.name,
    this.title,
    this.factionId,
    required this.level,
    required this.health,
    required this.maxHealth,
    required this.attack,
    required this.defense,
    this.weaponId,
    this.armorId,
    this.description,
    this.lore,
    this.imagePath,
    this.iconPath,
  });

  factory Knight.fromJson(Map<String, dynamic> json) {
    return Knight(
      id: json['id'] as int,
      name: json['name'] as String,
      title: json['title'] as String?,
      factionId: json['faction_id'] as int?,
      level: json['level'] as int,
      health: json['health'] as int,
      maxHealth: json['max_health'] as int,
      attack: json['attack'] as int,
      defense: json['defense'] as int,
      weaponId: json['weapon_id'] as int?,
      armorId: json['armor_id'] as int?,
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
      'title': title,
      'faction_id': factionId,
      'level': level,
      'health': health,
      'max_health': maxHealth,
      'attack': attack,
      'defense': defense,
      'weapon_id': weaponId,
      'armor_id': armorId,
      'description': description,
      'lore': lore,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}


