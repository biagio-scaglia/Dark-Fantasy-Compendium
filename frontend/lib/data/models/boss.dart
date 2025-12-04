class Boss {
  final int id;
  final String name;
  final String? title;
  final int level;
  final int health;
  final int maxHealth;
  final int attack;
  final int defense;
  final String? description;
  final String? lore;
  final List<int>? rewardIds;
  final String? imagePath;
  final String? iconPath;

  Boss({
    required this.id,
    required this.name,
    this.title,
    required this.level,
    required this.health,
    required this.maxHealth,
    required this.attack,
    required this.defense,
    this.description,
    this.lore,
    this.rewardIds,
    this.imagePath,
    this.iconPath,
  });

  factory Boss.fromJson(Map<String, dynamic> json) {
    return Boss(
      id: json['id'] as int,
      name: json['name'] as String,
      title: json['title'] as String?,
      level: json['level'] as int,
      health: json['health'] as int,
      maxHealth: json['max_health'] as int,
      attack: json['attack'] as int,
      defense: json['defense'] as int,
      description: json['description'] as String?,
      lore: json['lore'] as String?,
      rewardIds: json['reward_ids'] != null ? List<int>.from(json['reward_ids']) : null,
      imagePath: json['image_path'] as String?,
      iconPath: json['icon_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'level': level,
      'health': health,
      'max_health': maxHealth,
      'attack': attack,
      'defense': defense,
      'description': description,
      'lore': lore,
      'reward_ids': rewardIds,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}

