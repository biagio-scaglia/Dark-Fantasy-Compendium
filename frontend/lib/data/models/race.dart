class Race {
  final int id;
  final String name;
  final String? description;
  final String? size;
  final int? speed;
  final Map<String, dynamic>? abilityScoreIncreases;
  final List<String>? traits;
  final List<String>? languages;
  final List<String>? subraces;
  final String? imagePath;
  final String? iconPath;

  Race({
    required this.id,
    required this.name,
    this.description,
    this.size,
    this.speed,
    this.abilityScoreIncreases,
    this.traits,
    this.languages,
    this.subraces,
    this.imagePath,
    this.iconPath,
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      size: json['size'] as String?,
      speed: json['speed'] as int?,
      abilityScoreIncreases: json['ability_score_increases'] as Map<String, dynamic>?,
      traits: json['traits'] != null ? List<String>.from(json['traits']) : null,
      languages: json['languages'] != null ? List<String>.from(json['languages']) : null,
      subraces: json['subraces'] != null ? List<String>.from(json['subraces']) : null,
      imagePath: json['image_path'] as String?,
      iconPath: json['icon_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'size': size,
      'speed': speed,
      'ability_score_increases': abilityScoreIncreases,
      'traits': traits,
      'languages': languages,
      'subraces': subraces,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}


