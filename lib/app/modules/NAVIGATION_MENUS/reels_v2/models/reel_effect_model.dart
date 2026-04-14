/// Model representing a visual effect/filter that can be applied to a reel.
class ReelEffectModel {
  final String id;
  final String name;
  final String category;
  final String thumbnailUrl;
  final String? previewUrl;
  final Map<String, dynamic> parameters;
  final bool isPremium;
  final int usageCount;
  final String type; // 'filter', 'effect', 'ar', 'green_screen', 'transition'

  const ReelEffectModel({
    required this.id,
    required this.name,
    required this.category,
    required this.thumbnailUrl,
    this.previewUrl,
    this.parameters = const {},
    this.isPremium = false,
    this.usageCount = 0,
    this.type = 'filter',
  });

  factory ReelEffectModel.fromJson(Map<String, dynamic> json) {
    return ReelEffectModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      previewUrl: json['previewUrl'],
      parameters: Map<String, dynamic>.from(json['parameters'] ?? {}),
      isPremium: json['isPremium'] ?? false,
      usageCount: json['usageCount'] ?? 0,
      type: json['type'] ?? 'filter',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'thumbnailUrl': thumbnailUrl,
      'previewUrl': previewUrl,
      'parameters': parameters,
      'isPremium': isPremium,
      'usageCount': usageCount,
      'type': type,
    };
  }

  ReelEffectModel copyWith({
    String? id,
    String? name,
    String? category,
    String? thumbnailUrl,
    String? previewUrl,
    Map<String, dynamic>? parameters,
    bool? isPremium,
    int? usageCount,
    String? type,
  }) {
    return ReelEffectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      previewUrl: previewUrl ?? this.previewUrl,
      parameters: parameters ?? this.parameters,
      isPremium: isPremium ?? this.isPremium,
      usageCount: usageCount ?? this.usageCount,
      type: type ?? this.type,
    );
  }
}
