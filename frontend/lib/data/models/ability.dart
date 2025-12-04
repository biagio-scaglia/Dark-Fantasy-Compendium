class Ability {
  final int id;
  final String name;
  final String? description;
  final String? abilityType;
  final String? abilityScore;
  final int? modifier;
  final bool proficiencyBonus;
  final String? imagePath;
  final String? iconPath;

  Ability({
    required this.id,
    required this.name,
    this.description,
    this.abilityType,
    this.abilityScore,
    this.modifier,
    this.proficiencyBonus = false,
    this.imagePath,
    this.iconPath,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      abilityType: json['ability_type'] as String?,
      abilityScore: json['ability_score'] as String?,
      modifier: json['modifier'] as int?,
      proficiencyBonus: json['proficiency_bonus'] as bool? ?? false,
      imagePath: json['image_path'] as String?,
      iconPath: json['icon_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ability_type': abilityType,
      'ability_score': abilityScore,
      'modifier': modifier,
      'proficiency_bonus': proficiencyBonus,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}

