class ClassModel {
  final int id;
  final String name;
  final String? description;
  final String? hitDice;
  final int? hitPointsAt1stLevel;
  final String? hitPointsAtHigherLevels;
  final List<String>? proficiencies;
  final List<String>? savingThrows;
  final List<String>? startingEquipment;
  final List<String>? classFeatures;
  final String? spellcastingAbility;
  final String? imagePath;
  final String? iconPath;

  ClassModel({
    required this.id,
    required this.name,
    this.description,
    this.hitDice,
    this.hitPointsAt1stLevel,
    this.hitPointsAtHigherLevels,
    this.proficiencies,
    this.savingThrows,
    this.startingEquipment,
    this.classFeatures,
    this.spellcastingAbility,
    this.imagePath,
    this.iconPath,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      hitDice: json['hit_dice'] as String?,
      hitPointsAt1stLevel: json['hit_points_at_1st_level'] as int?,
      hitPointsAtHigherLevels: json['hit_points_at_higher_levels'] as String?,
      proficiencies: json['proficiencies'] != null ? List<String>.from(json['proficiencies']) : null,
      savingThrows: json['saving_throws'] != null ? List<String>.from(json['saving_throws']) : null,
      startingEquipment: json['starting_equipment'] != null ? List<String>.from(json['starting_equipment']) : null,
      classFeatures: json['class_features'] != null ? List<String>.from(json['class_features']) : null,
      spellcastingAbility: json['spellcasting_ability'] as String?,
      imagePath: json['image_path'] as String?,
      iconPath: json['icon_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'hit_dice': hitDice,
      'hit_points_at_1st_level': hitPointsAt1stLevel,
      'hit_points_at_higher_levels': hitPointsAtHigherLevels,
      'proficiencies': proficiencies,
      'saving_throws': savingThrows,
      'starting_equipment': startingEquipment,
      'class_features': classFeatures,
      'spellcasting_ability': spellcastingAbility,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}

