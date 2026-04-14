/// Model for reels V2 templates with beat markers.

class ReelTemplate {
  final String id;
  final String name;
  final String? authorId;
  final String? authorName;
  final String? thumbnailUrl;
  final String? previewVideoUrl;
  final String? soundId;
  final String? soundName;
  final int durationMs;
  final int clipCount;
  final List<BeatMarker> beatMarkers;
  final List<TemplateClipSlot> clipSlots;
  final String? filterPresetId;
  final Map<String, dynamic>? effectConfig;
  final int usageCount;
  final bool isTrending;
  final DateTime? createdAt;

  const ReelTemplate({
    required this.id,
    required this.name,
    this.authorId,
    this.authorName,
    this.thumbnailUrl,
    this.previewVideoUrl,
    this.soundId,
    this.soundName,
    this.durationMs = 0,
    this.clipCount = 0,
    this.beatMarkers = const [],
    this.clipSlots = const [],
    this.filterPresetId,
    this.effectConfig,
    this.usageCount = 0,
    this.isTrending = false,
    this.createdAt,
  });

  factory ReelTemplate.fromJson(Map<String, dynamic> json) {
    return ReelTemplate(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      authorId: json['authorId'],
      authorName: json['authorName'],
      thumbnailUrl: json['thumbnailUrl'],
      previewVideoUrl: json['previewVideoUrl'],
      soundId: json['soundId'],
      soundName: json['soundName'],
      durationMs: json['durationMs'] ?? 0,
      clipCount: json['clipCount'] ?? 0,
      beatMarkers: (json['beatMarkers'] as List?)
              ?.map((e) => BeatMarker.fromJson(e))
              .toList() ??
          [],
      clipSlots: (json['clipSlots'] as List?)
              ?.map((e) => TemplateClipSlot.fromJson(e))
              .toList() ??
          [],
      filterPresetId: json['filterPresetId'],
      effectConfig: json['effectConfig'],
      usageCount: json['usageCount'] ?? 0,
      isTrending: json['isTrending'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (authorId != null) 'authorId': authorId,
        if (authorName != null) 'authorName': authorName,
        if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
        if (previewVideoUrl != null) 'previewVideoUrl': previewVideoUrl,
        if (soundId != null) 'soundId': soundId,
        if (soundName != null) 'soundName': soundName,
        'durationMs': durationMs,
        'clipCount': clipCount,
        'beatMarkers': beatMarkers.map((e) => e.toJson()).toList(),
        'clipSlots': clipSlots.map((e) => e.toJson()).toList(),
        if (filterPresetId != null) 'filterPresetId': filterPresetId,
        if (effectConfig != null) 'effectConfig': effectConfig,
        'usageCount': usageCount,
        'isTrending': isTrending,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };
}

class BeatMarker {
  final int timestampMs;
  final double intensity; // 0.0-1.0, how strong the beat is
  final String type; // 'beat', 'drop', 'transition'

  const BeatMarker({
    required this.timestampMs,
    this.intensity = 1.0,
    this.type = 'beat',
  });

  factory BeatMarker.fromJson(Map<String, dynamic> json) {
    return BeatMarker(
      timestampMs: json['timestampMs'] ?? 0,
      intensity: (json['intensity'] as num?)?.toDouble() ?? 1.0,
      type: json['type'] ?? 'beat',
    );
  }

  Map<String, dynamic> toJson() => {
        'timestampMs': timestampMs,
        'intensity': intensity,
        'type': type,
      };
}

class TemplateClipSlot {
  final int index;
  final int startMs;
  final int durationMs;
  final String? transitionType; // none, fade, slide, zoom, dissolve
  final double? speed;
  final String? filterPresetId;

  const TemplateClipSlot({
    required this.index,
    required this.startMs,
    required this.durationMs,
    this.transitionType,
    this.speed,
    this.filterPresetId,
  });

  factory TemplateClipSlot.fromJson(Map<String, dynamic> json) {
    return TemplateClipSlot(
      index: json['index'] ?? 0,
      startMs: json['startMs'] ?? 0,
      durationMs: json['durationMs'] ?? 0,
      transitionType: json['transitionType'],
      speed: (json['speed'] as num?)?.toDouble(),
      filterPresetId: json['filterPresetId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'index': index,
        'startMs': startMs,
        'durationMs': durationMs,
        if (transitionType != null) 'transitionType': transitionType,
        if (speed != null) 'speed': speed,
        if (filterPresetId != null) 'filterPresetId': filterPresetId,
      };
}
