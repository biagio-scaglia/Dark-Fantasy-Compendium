class Spell {
  final int id;
  final String name;
  final int level;
  final String? school;
  final String? castingTime;
  final String? range;
  final List<String>? components;
  final String? materialComponents;
  final String? duration;
  final String? description;
  final String? higherLevel;
  final List<int>? allowedClassIds;
  final bool ritual;
  final bool concentration;
  final String? imagePath;
  final String? iconPath;

  Spell({
    required this.id,
    required this.name,
    required this.level,
    this.school,
    this.castingTime,
    this.range,
    this.components,
    this.materialComponents,
    this.duration,
    this.description,
    this.higherLevel,
    this.allowedClassIds,
    this.ritual = false,
    this.concentration = false,
    this.imagePath,
    this.iconPath,
  });

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      id: json['id'] as int,
      name: json['name'] as String,
      level: json['level'] as int,
      school: json['school'] as String?,
      castingTime: json['casting_time'] as String?,
      range: json['range'] as String?,
      components: json['components'] != null ? List<String>.from(json['components']) : null,
      materialComponents: json['material_components'] as String?,
      duration: json['duration'] as String?,
      description: json['description'] as String?,
      higherLevel: json['higher_level'] as String?,
      allowedClassIds: json['allowed_class_ids'] != null ? List<int>.from(json['allowed_class_ids']) : null,
      ritual: json['ritual'] as bool? ?? false,
      concentration: json['concentration'] as bool? ?? false,
      imagePath: json['image_path'] as String?,
      iconPath: json['icon_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'school': school,
      'casting_time': castingTime,
      'range': range,
      'components': components,
      'material_components': materialComponents,
      'duration': duration,
      'description': description,
      'higher_level': higherLevel,
      'allowed_class_ids': allowedClassIds,
      'ritual': ritual,
      'concentration': concentration,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}

