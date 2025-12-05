class Character {
  final int id;
  final String name;
  final int? classId;
  final int? raceId;
  final int level;
  final Map<String, dynamic>? stats;
  final String? description;
  final String? imagePath;
  final String? iconPath;

  Character({
    required this.id,
    required this.name,
    this.classId,
    this.raceId,
    this.level = 1,
    this.stats,
    this.description,
    this.imagePath,
    this.iconPath,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      classId: json['class_id'] as int?,
      raceId: json['race_id'] as int?,
      level: json['level'] as int? ?? 1,
      stats: json['stats'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      imagePath: json['image_path'] as String?,
      iconPath: json['icon_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'class_id': classId,
      'race_id': raceId,
      'level': level,
      'stats': stats,
      'description': description,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}


