/// Overview analytics for all reels
class ReelAnalyticsOverview {
  final int totalPlays;
  final int totalLikes;
  final int totalComments;
  final int totalShares;
  final int totalSaves;
  final double avgWatchTimeSeconds;
  final int totalReach;
  final int totalFollowersGained;
  final List<Map<String, dynamic>> playsOverTime;

  ReelAnalyticsOverview({
    this.totalPlays = 0,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.totalShares = 0,
    this.totalSaves = 0,
    this.avgWatchTimeSeconds = 0.0,
    this.totalReach = 0,
    this.totalFollowersGained = 0,
    this.playsOverTime = const [],
  });

  factory ReelAnalyticsOverview.fromMap(Map<String, dynamic> map) {
    return ReelAnalyticsOverview(
      totalPlays: map['totalPlays'] ?? map['total_plays'] ?? 0,
      totalLikes: map['totalLikes'] ?? map['total_likes'] ?? 0,
      totalComments: map['totalComments'] ?? map['total_comments'] ?? 0,
      totalShares: map['totalShares'] ?? map['total_shares'] ?? 0,
      totalSaves: map['totalSaves'] ?? map['total_saves'] ?? 0,
      avgWatchTimeSeconds:
          (map['avgWatchTimeSeconds'] ?? map['avg_watch_time'] ?? 0)
              .toDouble(),
      totalReach: map['totalReach'] ?? map['total_reach'] ?? 0,
      totalFollowersGained:
          map['totalFollowersGained'] ?? map['followers_gained'] ?? 0,
      playsOverTime: (map['playsOverTime'] ?? map['plays_over_time'] ?? [])
          .cast<Map<String, dynamic>>(),
    );
  }
}

/// Per-reel insight data
class ReelInsightModel {
  final String reelId;
  final int plays;
  final int likes;
  final int comments;
  final int shares;
  final int saves;
  final int reach;
  final double avgWatchTimeSeconds;
  final Map<String, double> reachSources;
  final bool hasAbThumbnail;
  final String? thumbnailAUrl;
  final String? thumbnailBUrl;
  final int thumbnailAImpressions;
  final int thumbnailBImpressions;
  final double thumbnailACtr;
  final double thumbnailBCtr;

  ReelInsightModel({
    required this.reelId,
    this.plays = 0,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.saves = 0,
    this.reach = 0,
    this.avgWatchTimeSeconds = 0.0,
    this.reachSources = const {},
    this.hasAbThumbnail = false,
    this.thumbnailAUrl,
    this.thumbnailBUrl,
    this.thumbnailAImpressions = 0,
    this.thumbnailBImpressions = 0,
    this.thumbnailACtr = 0.0,
    this.thumbnailBCtr = 0.0,
  });

  factory ReelInsightModel.fromMap(Map<String, dynamic> map) {
    final sources = map['reachSources'] ?? map['reach_sources'] ?? {};
    return ReelInsightModel(
      reelId: map['reelId'] ?? map['reel_id'] ?? '',
      plays: map['plays'] ?? 0,
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
      shares: map['shares'] ?? 0,
      saves: map['saves'] ?? 0,
      reach: map['reach'] ?? 0,
      avgWatchTimeSeconds:
          (map['avgWatchTimeSeconds'] ?? map['avg_watch_time'] ?? 0)
              .toDouble(),
      reachSources: (sources is Map)
          ? sources.map((k, v) => MapEntry(k.toString(), (v ?? 0).toDouble()))
          : {},
      hasAbThumbnail: map['hasAbThumbnail'] ?? map['has_ab_thumbnail'] ?? false,
      thumbnailAUrl: map['thumbnailAUrl'] ?? map['thumbnail_a_url'],
      thumbnailBUrl: map['thumbnailBUrl'] ?? map['thumbnail_b_url'],
      thumbnailAImpressions:
          map['thumbnailAImpressions'] ?? map['thumbnail_a_impressions'] ?? 0,
      thumbnailBImpressions:
          map['thumbnailBImpressions'] ?? map['thumbnail_b_impressions'] ?? 0,
      thumbnailACtr:
          (map['thumbnailACtr'] ?? map['thumbnail_a_ctr'] ?? 0).toDouble(),
      thumbnailBCtr:
          (map['thumbnailBCtr'] ?? map['thumbnail_b_ctr'] ?? 0).toDouble(),
    );
  }
}

/// Audience demographics
class AudienceDemographics {
  final double genderMale;
  final double genderFemale;
  final Map<String, double> ageBrackets;
  final List<Map<String, dynamic>> topCities;
  final List<int> peakHours;

  AudienceDemographics({
    this.genderMale = 0.0,
    this.genderFemale = 0.0,
    this.ageBrackets = const {},
    this.topCities = const [],
    this.peakHours = const [],
  });

  factory AudienceDemographics.fromMap(Map<String, dynamic> map) {
    final ages = map['ageBrackets'] ?? map['age_brackets'] ?? {};
    final cities = map['topCities'] ?? map['top_cities'] ?? [];
    final hours = map['peakHours'] ?? map['peak_hours'] ?? [];

    return AudienceDemographics(
      genderMale:
          (map['genderMale'] ?? map['gender_male'] ?? 0).toDouble(),
      genderFemale:
          (map['genderFemale'] ?? map['gender_female'] ?? 0).toDouble(),
      ageBrackets: (ages is Map)
          ? ages.map((k, v) => MapEntry(k.toString(), (v ?? 0).toDouble()))
          : {},
      topCities: (cities is List)
          ? cities.map((e) => Map<String, dynamic>.from(e)).toList()
          : [],
      peakHours: (hours is List) ? hours.cast<int>() : [],
    );
  }
}
