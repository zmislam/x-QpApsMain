/// Viral Content Models — Phase 4
/// All tier labels, multipliers, and durations are dynamic from EarningConfigService

class ViralPostInfo {
  final String postId;
  final String viralTierKey; // 'rising', 'viral', 'mega_viral', 'expired'
  final double viralScore;
  final double multiplier;
  final String label;
  final int durationHours;
  final DateTime? detectedAt;
  final DateTime? expiresAt;
  final ViralMetrics metrics;
  final double bonusEarned;

  ViralPostInfo({
    required this.postId,
    required this.viralTierKey,
    required this.viralScore,
    required this.multiplier,
    required this.label,
    required this.durationHours,
    this.detectedAt,
    this.expiresAt,
    required this.metrics,
    this.bonusEarned = 0,
  });

  factory ViralPostInfo.fromJson(Map<String, dynamic> json) => ViralPostInfo(
        postId: json['postId']?.toString() ?? '',
        viralTierKey: json['viralTierKey']?.toString() ?? 'expired',
        viralScore: (json['viralScore'] ?? 0).toDouble(),
        multiplier: (json['multiplier'] ?? 1.0).toDouble(),
        label: json['label']?.toString() ?? '',
        durationHours: json['durationHours'] ?? 0,
        detectedAt: json['detectedAt'] != null
            ? DateTime.tryParse(json['detectedAt'].toString())
            : null,
        expiresAt: json['expiresAt'] != null
            ? DateTime.tryParse(json['expiresAt'].toString())
            : null,
        metrics: ViralMetrics.fromJson(json['metrics'] ?? {}),
        bonusEarned: (json['bonusEarned'] ?? 0).toDouble(),
      );

  bool get isActive =>
      viralTierKey != 'expired' &&
      expiresAt != null &&
      expiresAt!.isAfter(DateTime.now());
}

class ViralMetrics {
  final int views;
  final int shares;
  final int reactions;
  final int comments;
  final double engagementRate;

  ViralMetrics({
    this.views = 0,
    this.shares = 0,
    this.reactions = 0,
    this.comments = 0,
    this.engagementRate = 0,
  });

  factory ViralMetrics.fromJson(Map<String, dynamic> json) => ViralMetrics(
        views: json['views'] ?? 0,
        shares: json['shares'] ?? 0,
        reactions: json['reactions'] ?? 0,
        comments: json['comments'] ?? 0,
        engagementRate: (json['engagementRate'] ?? 0).toDouble(),
      );
}

class ViralScoreBreakdown {
  final double totalScore;
  final String tierKey;
  final String tierLabel;
  final double multiplier;
  final List<ScoreFactor> factors;
  final DateTime calculatedAt;

  ViralScoreBreakdown({
    required this.totalScore,
    required this.tierKey,
    required this.tierLabel,
    required this.multiplier,
    required this.factors,
    required this.calculatedAt,
  });

  factory ViralScoreBreakdown.fromJson(Map<String, dynamic> json) =>
      ViralScoreBreakdown(
        totalScore: (json['totalScore'] ?? 0).toDouble(),
        tierKey: json['tierKey']?.toString() ?? '',
        tierLabel: json['tierLabel']?.toString() ?? '',
        multiplier: (json['multiplier'] ?? 1.0).toDouble(),
        factors: (json['factors'] as List?)
                ?.map((e) => ScoreFactor.fromJson(e))
                .toList() ??
            [],
        calculatedAt: DateTime.tryParse(
                json['calculatedAt']?.toString() ?? '') ??
            DateTime.now(),
      );
}

class ScoreFactor {
  final String label;
  final double value;
  final double weight;
  final double weighted;

  ScoreFactor({
    required this.label,
    required this.value,
    required this.weight,
    required this.weighted,
  });

  factory ScoreFactor.fromJson(Map<String, dynamic> json) => ScoreFactor(
        label: json['label']?.toString() ?? '',
        value: (json['value'] ?? 0).toDouble(),
        weight: (json['weight'] ?? 0).toDouble(),
        weighted: (json['weighted'] ?? 0).toDouble(),
      );
}

class TrendingPost {
  final String postId;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String? thumbnail;
  final String? textPreview;
  final String viralTierKey;
  final String viralLabel;
  final double viralScore;
  final double multiplier;
  final ViralMetrics metrics;
  final DateTime? createdAt;

  TrendingPost({
    required this.postId,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    this.thumbnail,
    this.textPreview,
    required this.viralTierKey,
    required this.viralLabel,
    required this.viralScore,
    required this.multiplier,
    required this.metrics,
    this.createdAt,
  });

  factory TrendingPost.fromJson(Map<String, dynamic> json) => TrendingPost(
        postId: json['postId']?.toString() ?? json['_id']?.toString() ?? '',
        authorId: json['authorId']?.toString() ?? '',
        authorName: json['authorName']?.toString() ?? '',
        authorAvatar: json['authorAvatar']?.toString(),
        thumbnail: json['thumbnail']?.toString(),
        textPreview: json['textPreview']?.toString(),
        viralTierKey: json['viralTierKey']?.toString() ?? '',
        viralLabel: json['viralLabel']?.toString() ?? '',
        viralScore: (json['viralScore'] ?? 0).toDouble(),
        multiplier: (json['multiplier'] ?? 1.0).toDouble(),
        metrics: ViralMetrics.fromJson(json['metrics'] ?? {}),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
}

class MyViralPostsResponse {
  final List<ViralPostInfo> active;
  final List<ViralPostInfo> historical;

  MyViralPostsResponse({
    this.active = const [],
    this.historical = const [],
  });

  factory MyViralPostsResponse.fromJson(Map<String, dynamic> json) =>
      MyViralPostsResponse(
        active: (json['active'] as List?)
                ?.map((e) => ViralPostInfo.fromJson(e))
                .toList() ??
            [],
        historical: (json['historical'] as List?)
                ?.map((e) => ViralPostInfo.fromJson(e))
                .toList() ??
            [],
      );
}
