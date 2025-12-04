class Item {
  final int id;
  final String name;
  final String? type;
  final String? description;
  final String? effect;
  final int? value;
  final String? rarity;
  final String? lore;
  final int? ownerId;
  final String? imagePath;
  final String? iconPath;

  Item({
    required this.id,
    required this.name,
    this.type,
    this.description,
    this.effect,
    this.value,
    this.rarity,
    this.lore,
    this.ownerId,
    this.imagePath,
    this.iconPath,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String?,
      description: json['description'] as String?,
      effect: json['effect'] as String?,
      value: json['value'] as int?,
      rarity: json['rarity'] as String?,
      lore: json['lore'] as String?,
      ownerId: json['owner_id'] as int?,
      imagePath: json['image_path'] as String?,
      iconPath: json['icon_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'effect': effect,
      'value': value,
      'rarity': rarity,
      'lore': lore,
      'owner_id': ownerId,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}

