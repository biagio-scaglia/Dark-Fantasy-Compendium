class MapModel {
  final int id;
  final String name;
  final String? description;
  final String? imagePath;
  final int? width;
  final int? height;
  final List<Map<String, dynamic>>? markers;
  final List<String>? layers;
  final int? campaignId;
  final String? notes;

  MapModel({
    required this.id,
    required this.name,
    this.description,
    this.imagePath,
    this.width,
    this.height,
    this.markers,
    this.layers,
    this.campaignId,
    this.notes,
  });

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      imagePath: json['image_path'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      markers: json['markers'] != null ? List<Map<String, dynamic>>.from(json['markers']) : null,
      layers: json['layers'] != null ? List<String>.from(json['layers']) : null,
      campaignId: json['campaign_id'] as int?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_path': imagePath,
      'width': width,
      'height': height,
      'markers': markers,
      'layers': layers,
      'campaign_id': campaignId,
      'notes': notes,
    };
  }
}


