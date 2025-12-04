class Party {
  final int id;
  final String name;
  final String? description;
  final int? campaignId;
  final List<int>? memberIds;
  final int level;
  final int experiencePoints;
  final String? notes;
  final String? imagePath;
  final String? iconPath;

  Party({
    required this.id,
    required this.name,
    this.description,
    this.campaignId,
    this.memberIds,
    this.level = 1,
    this.experiencePoints = 0,
    this.notes,
    this.imagePath,
    this.iconPath,
  });

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      campaignId: json['campaign_id'] as int?,
      memberIds: json['member_ids'] != null ? List<int>.from(json['member_ids']) : null,
      level: json['level'] as int? ?? 1,
      experiencePoints: json['experience_points'] as int? ?? 0,
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
      'campaign_id': campaignId,
      'member_ids': memberIds,
      'level': level,
      'experience_points': experiencePoints,
      'notes': notes,
      'image_path': imagePath,
      'icon_path': iconPath,
    };
  }
}

