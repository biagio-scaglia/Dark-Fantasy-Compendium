class Lore {
  final int id;
  final String title;
  final String? category;
  final String? content;
  final String? relatedEntityType;
  final int? relatedEntityId;
  final String? imagePath;

  Lore({
    required this.id,
    required this.title,
    this.category,
    this.content,
    this.relatedEntityType,
    this.relatedEntityId,
    this.imagePath,
  });

  factory Lore.fromJson(Map<String, dynamic> json) {
    return Lore(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String?,
      content: json['content'] as String?,
      relatedEntityType: json['related_entity_type'] as String?,
      relatedEntityId: json['related_entity_id'] as int?,
      imagePath: json['image_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'content': content,
      'related_entity_type': relatedEntityType,
      'related_entity_id': relatedEntityId,
      'image_path': imagePath,
    };
  }
}

