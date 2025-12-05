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
    // Handle allowed_class_ids: can be List<int>, List<String>, or null
    List<int>? allowedClassIds;
    if (json['allowed_class_ids'] != null) {
      final ids = json['allowed_class_ids'] as List;
      // Filter to keep only integers
      final intIds = ids.whereType<int>().toList();
      allowedClassIds = intIds.isNotEmpty ? intIds : null;
    } else if (json['classes'] != null) {
      // If classes is still present (as strings), set to null for now
      // The SpellService can handle conversion later if needed
      allowedClassIds = null;
    }
    
    return Spell(
      id: json['id'] as int,
      name: json['name'] as String,
      level: json['level'] is int ? json['level'] as int : int.tryParse(json['level'].toString()) ?? 0,
      school: json['school'] as String?,
      castingTime: json['casting_time'] as String?,
      range: json['range'] as String?,
      components: json['components'] != null ? List<String>.from(json['components']) : null,
      materialComponents: json['material_components'] as String?,
      duration: json['duration'] as String?,
      description: json['description'] as String?,
      higherLevel: json['higher_level'] as String?,
      allowedClassIds: allowedClassIds,
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


