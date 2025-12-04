class Campaign {
  final int id;
  final String name;
  final String? description;
  final String? dungeonMaster;
  final List<String>? players;
  final List<int>? characterIds;
  final List<Map<String, dynamic>>? sessions;
  final int currentLevel;
  final String? setting;
  final String? notes;
  final String? imagePath;
  final String? iconPath;

  Campaign({
    required this.id,
    required this.name,
    this.description,
    this.dungeonMaster,
    this.players,
    this.characterIds,
    this.sessions,
    this.currentLevel = 1,
    this.setting,
    this.notes,
    this.imagePath,
    this.iconPath,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      dungeonMaster: json['dungeon_master'] as String?,
      players: json['players'] != null ? List<String>.from(json['players']) : null,
      characterIds: json['character_ids'] != null ? List<int>.from(json['character_ids']) : null,
      sessions: json['sessions'] != null ? List<Map<String, dynamic>>.from(json['sessions']) : null,
      currentLevel: json['current_level'] as int? ?? 1,
      setting: json['setting'] as String?,
      notes: json['notes'] as String?,
      imagePath: json['image_path'] as String?,
      iconPath: json['icon_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dungeon_master': dungeonMaster,
      'players': players,
      'character_ids': characterIds,
      'sessions': sessions,
      'current_level': currentLevel,
      'setting': setting,
      'notes': notes,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}

