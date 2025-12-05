class Faction {
  final int id;
  final String name;
  final String? description;
  final String? lore;
  final String? color;
  final String? imagePath;
  final String? iconPath;

  Faction({
    required this.id,
    required this.name,
    this.description,
    this.lore,
    this.color,
    this.imagePath,
    this.iconPath,
  });

  factory Faction.fromJson(Map<String, dynamic> json) {
    return Faction(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      lore: json['lore'] as String?,
      color: json['color'] as String?,
      imagePath: json['image_path'] as String?,
      iconPath: json['icon_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'lore': lore,
      'color': color,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}


