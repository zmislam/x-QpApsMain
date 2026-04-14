/// Model for reels V2 filter presets and custom adjustments.

class ReelFilterPreset {
  final String id;
  final String name;
  final String? thumbnailUrl;
  final String category; // 'color', 'mood', 'vintage', 'film', 'artistic'
  final List<double>? colorMatrix; // 5x4 matrix
  final Map<String, double>? adjustments; // brightness, contrast, etc.
  final bool isPremium;
  final int sortOrder;

  const ReelFilterPreset({
    required this.id,
    required this.name,
    this.thumbnailUrl,
    this.category = 'color',
    this.colorMatrix,
    this.adjustments,
    this.isPremium = false,
    this.sortOrder = 0,
  });

  factory ReelFilterPreset.fromJson(Map<String, dynamic> json) {
    return ReelFilterPreset(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      category: json['category'] ?? 'color',
      colorMatrix: (json['colorMatrix'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      adjustments: (json['adjustments'] as Map?)?.map(
        (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
      ),
      isPremium: json['isPremium'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
        'category': category,
        if (colorMatrix != null) 'colorMatrix': colorMatrix,
        if (adjustments != null) 'adjustments': adjustments,
        'isPremium': isPremium,
        'sortOrder': sortOrder,
      };
}

class ReelColorAdjustments {
  double brightness;
  double contrast;
  double saturation;
  double warmth;
  double vignette;
  double sharpen;
  double fade;
  double highlights;
  double shadows;
  double grain;

  ReelColorAdjustments({
    this.brightness = 0.0,
    this.contrast = 0.0,
    this.saturation = 0.0,
    this.warmth = 0.0,
    this.vignette = 0.0,
    this.sharpen = 0.0,
    this.fade = 0.0,
    this.highlights = 0.0,
    this.shadows = 0.0,
    this.grain = 0.0,
  });

  bool get hasAdjustments =>
      brightness != 0 ||
      contrast != 0 ||
      saturation != 0 ||
      warmth != 0 ||
      vignette != 0 ||
      sharpen != 0 ||
      fade != 0 ||
      highlights != 0 ||
      shadows != 0 ||
      grain != 0;

  void reset() {
    brightness = 0.0;
    contrast = 0.0;
    saturation = 0.0;
    warmth = 0.0;
    vignette = 0.0;
    sharpen = 0.0;
    fade = 0.0;
    highlights = 0.0;
    shadows = 0.0;
    grain = 0.0;
  }

  Map<String, double> toMap() => {
        'brightness': brightness,
        'contrast': contrast,
        'saturation': saturation,
        'warmth': warmth,
        'vignette': vignette,
        'sharpen': sharpen,
        'fade': fade,
        'highlights': highlights,
        'shadows': shadows,
        'grain': grain,
      };

  factory ReelColorAdjustments.fromMap(Map<String, dynamic> map) {
    return ReelColorAdjustments(
      brightness: (map['brightness'] as num?)?.toDouble() ?? 0.0,
      contrast: (map['contrast'] as num?)?.toDouble() ?? 0.0,
      saturation: (map['saturation'] as num?)?.toDouble() ?? 0.0,
      warmth: (map['warmth'] as num?)?.toDouble() ?? 0.0,
      vignette: (map['vignette'] as num?)?.toDouble() ?? 0.0,
      sharpen: (map['sharpen'] as num?)?.toDouble() ?? 0.0,
      fade: (map['fade'] as num?)?.toDouble() ?? 0.0,
      highlights: (map['highlights'] as num?)?.toDouble() ?? 0.0,
      shadows: (map['shadows'] as num?)?.toDouble() ?? 0.0,
      grain: (map['grain'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class AREffect {
  final String id;
  final String name;
  final String? iconUrl;
  final String? previewUrl;
  final String category; // 'face', 'background', 'world', 'beauty'
  final String? assetPath;
  final bool isDownloaded;
  final int usageCount;

  const AREffect({
    required this.id,
    required this.name,
    this.iconUrl,
    this.previewUrl,
    this.category = 'face',
    this.assetPath,
    this.isDownloaded = false,
    this.usageCount = 0,
  });

  factory AREffect.fromJson(Map<String, dynamic> json) {
    return AREffect(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      iconUrl: json['iconUrl'],
      previewUrl: json['previewUrl'],
      category: json['category'] ?? 'face',
      assetPath: json['assetPath'],
      isDownloaded: json['isDownloaded'] ?? false,
      usageCount: json['usageCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (iconUrl != null) 'iconUrl': iconUrl,
        if (previewUrl != null) 'previewUrl': previewUrl,
        'category': category,
        if (assetPath != null) 'assetPath': assetPath,
        'isDownloaded': isDownloaded,
        'usageCount': usageCount,
      };
}

enum GreenScreenSource { image, video, color }

class GreenScreenConfig {
  final GreenScreenSource source;
  final String? mediaPath;
  final int? backgroundColor; // ARGB color value
  final double sensitivity;
  final double smoothing;

  const GreenScreenConfig({
    this.source = GreenScreenSource.image,
    this.mediaPath,
    this.backgroundColor,
    this.sensitivity = 0.4,
    this.smoothing = 0.2,
  });

  GreenScreenConfig copyWith({
    GreenScreenSource? source,
    String? mediaPath,
    int? backgroundColor,
    double? sensitivity,
    double? smoothing,
  }) {
    return GreenScreenConfig(
      source: source ?? this.source,
      mediaPath: mediaPath ?? this.mediaPath,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      sensitivity: sensitivity ?? this.sensitivity,
      smoothing: smoothing ?? this.smoothing,
    );
  }
}
