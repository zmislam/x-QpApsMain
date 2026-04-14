/// Earning Config Models — Mirrors qp-api RevenueShareConfig (admin-managed)
/// All values are fetched from /api/earning/score-weights and configured via qp-admin.
/// NEVER hardcode any of these values in UI code.

class EarningConfig {
  // Basic config
  final double revenueSharePercentage;
  final String distributionTime;
  final String distributionMode;
  final double maxUserSharePercentage;

  // Score Weights (admin-configurable per activity)
  final Map<String, double> scoreWeights;

  // Bonus Multipliers
  final Map<String, double> bonusMultipliers;

  // Streak Thresholds
  final int streakTier1Days;
  final int streakTier2Days;
  final int streakTier3Days;

  // User Eligibility
  final double minEngagementScore;
  final int minAccountAgeDays;
  final bool monetizationEnabled;

  // Sub-configs (feature-flagged)
  final PageMonetizationConfig? pageMonetization;
  final TierConfig? tierConfig;
  final ViralConfig? viralConfig;
  final AntiAbuseConfig? antiAbuse;

  EarningConfig({
    this.revenueSharePercentage = 50.0,
    this.distributionTime = '00:00',
    this.distributionMode = 'score_based',
    this.maxUserSharePercentage = 10.0,
    this.scoreWeights = const {},
    this.bonusMultipliers = const {},
    this.streakTier1Days = 7,
    this.streakTier2Days = 30,
    this.streakTier3Days = 90,
    this.minEngagementScore = 1.0,
    this.minAccountAgeDays = 7,
    this.monetizationEnabled = true,
    this.pageMonetization,
    this.tierConfig,
    this.viralConfig,
    this.antiAbuse,
  });

  factory EarningConfig.fromJson(Map<String, dynamic> json) {
    // Parse score_weights
    final swRaw = json['score_weights'];
    final Map<String, double> parsedWeights = {};
    if (swRaw is Map) {
      swRaw.forEach((k, v) {
        parsedWeights[k.toString()] = (v ?? 0).toDouble();
      });
    }

    // Parse bonus_multipliers
    final bmRaw = json['bonus_multipliers'];
    final Map<String, double> parsedBonuses = {};
    if (bmRaw is Map) {
      bmRaw.forEach((k, v) {
        parsedBonuses[k.toString()] = (v ?? 0).toDouble();
      });
    }

    // Parse streak_thresholds
    final st = json['streak_thresholds'] as Map<String, dynamic>? ?? {};

    // Parse eligible_user_criteria
    final euc = json['eligible_user_criteria'] as Map<String, dynamic>? ?? {};

    return EarningConfig(
      revenueSharePercentage:
          (json['revenue_share_percentage'] ?? 50).toDouble(),
      distributionTime: json['distribution_time']?.toString() ?? '00:00',
      distributionMode:
          json['distribution_mode']?.toString() ?? 'score_based',
      maxUserSharePercentage:
          (json['max_user_share_percentage'] ?? 10).toDouble(),
      scoreWeights: parsedWeights,
      bonusMultipliers: parsedBonuses,
      streakTier1Days: _safeInt(st['tier_1_days'], fallback: 7),
      streakTier2Days: _safeInt(st['tier_2_days'], fallback: 30),
      streakTier3Days: _safeInt(st['tier_3_days'], fallback: 90),
      minEngagementScore:
          (euc['min_engagement_score'] ?? 1).toDouble(),
      minAccountAgeDays: _safeInt(euc['min_account_age_days'], fallback: 7),
      monetizationEnabled: euc['monetization_enabled'] != false,
      pageMonetization: json['page_monetization'] is Map<String, dynamic>
          ? PageMonetizationConfig.fromJson(json['page_monetization'])
          : null,
      tierConfig: json['tier_config'] is Map<String, dynamic>
          ? TierConfig.fromJson(json['tier_config'])
          : null,
      viralConfig: json['viral_config'] is Map<String, dynamic>
          ? ViralConfig.fromJson(json['viral_config'])
          : null,
      antiAbuse: json['page_anti_abuse'] is Map<String, dynamic>
          ? AntiAbuseConfig.fromJson(json['page_anti_abuse'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'revenue_share_percentage': revenueSharePercentage,
        'distribution_time': distributionTime,
        'distribution_mode': distributionMode,
        'max_user_share_percentage': maxUserSharePercentage,
        'score_weights': scoreWeights,
        'bonus_multipliers': bonusMultipliers,
        'streak_thresholds': {
          'tier_1_days': streakTier1Days,
          'tier_2_days': streakTier2Days,
          'tier_3_days': streakTier3Days,
        },
        'eligible_user_criteria': {
          'min_engagement_score': minEngagementScore,
          'min_account_age_days': minAccountAgeDays,
          'monetization_enabled': monetizationEnabled,
        },
        if (pageMonetization != null)
          'page_monetization': pageMonetization!.toJson(),
        if (tierConfig != null) 'tier_config': tierConfig!.toJson(),
        if (viralConfig != null) 'viral_config': viralConfig!.toJson(),
        if (antiAbuse != null) 'page_anti_abuse': antiAbuse!.toJson(),
      };
}

// ─────────────────────────────────────────────────
// Page Monetization Config
// ─────────────────────────────────────────────────

class PageMonetizationConfig {
  final bool enabled;
  final int minPageAgeDays;
  final int minFollowers;
  final int minMonthlyViews;
  final int minContentCount;
  final double minEngagementRate;
  final bool requireOwnerMonetized;
  final bool requirePageVerified;
  final bool autoApproveWhenEligible;
  final int reapplyCooldownDays;
  final int maxPagesPerUser;

  PageMonetizationConfig({
    this.enabled = false,
    this.minPageAgeDays = 30,
    this.minFollowers = 1000,
    this.minMonthlyViews = 10000,
    this.minContentCount = 20,
    this.minEngagementRate = 2.0,
    this.requireOwnerMonetized = true,
    this.requirePageVerified = false,
    this.autoApproveWhenEligible = false,
    this.reapplyCooldownDays = 30,
    this.maxPagesPerUser = 5,
  });

  factory PageMonetizationConfig.fromJson(Map<String, dynamic> json) {
    return PageMonetizationConfig(
      enabled: json['enabled'] == true,
      minPageAgeDays: _safeInt(json['min_page_age_days'], fallback: 30),
      minFollowers: _safeInt(json['min_followers'], fallback: 1000),
      minMonthlyViews: _safeInt(json['min_monthly_views'], fallback: 10000),
      minContentCount: _safeInt(json['min_content_count'], fallback: 20),
      minEngagementRate:
          (json['min_engagement_rate'] ?? 2.0).toDouble(),
      requireOwnerMonetized: json['require_owner_monetized'] != false,
      requirePageVerified: json['require_page_verified'] == true,
      autoApproveWhenEligible: json['auto_approve_when_eligible'] == true,
      reapplyCooldownDays:
          _safeInt(json['reapply_cooldown_days'], fallback: 30),
      maxPagesPerUser: _safeInt(json['max_pages_per_user'], fallback: 5),
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'min_page_age_days': minPageAgeDays,
        'min_followers': minFollowers,
        'min_monthly_views': minMonthlyViews,
        'min_content_count': minContentCount,
        'min_engagement_rate': minEngagementRate,
        'require_owner_monetized': requireOwnerMonetized,
        'require_page_verified': requirePageVerified,
        'auto_approve_when_eligible': autoApproveWhenEligible,
        'reapply_cooldown_days': reapplyCooldownDays,
        'max_pages_per_user': maxPagesPerUser,
      };
}

// ─────────────────────────────────────────────────
// Tier Config
// ─────────────────────────────────────────────────

class TierConfig {
  final bool enabled;
  final int evaluationPeriodDays;
  final int demotionGracePeriodDays;
  final double maxTotalMultiplier;
  final List<TierDefinition> userTiers;
  final List<TierDefinition> pageTiers;
  final Map<String, double> userScoreWeights;
  final Map<String, double> pageScoreWeights;

  TierConfig({
    this.enabled = false,
    this.evaluationPeriodDays = 30,
    this.demotionGracePeriodDays = 14,
    this.maxTotalMultiplier = 3.0,
    this.userTiers = const [],
    this.pageTiers = const [],
    this.userScoreWeights = const {},
    this.pageScoreWeights = const {},
  });

  factory TierConfig.fromJson(Map<String, dynamic> json) {
    // Parse score weight maps
    Map<String, double> _parseWeightMap(dynamic raw) {
      final Map<String, double> result = {};
      if (raw is Map) {
        raw.forEach((k, v) => result[k.toString()] = (v ?? 0).toDouble());
      }
      return result;
    }

    return TierConfig(
      enabled: json['enabled'] == true,
      evaluationPeriodDays:
          _safeInt(json['evaluation_period_days'], fallback: 30),
      demotionGracePeriodDays:
          _safeInt(json['demotion_grace_period_days'], fallback: 14),
      maxTotalMultiplier:
          (json['max_total_multiplier'] ?? 3.0).toDouble(),
      userTiers: (json['user_tiers'] as List?)
              ?.map((e) =>
                  TierDefinition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pageTiers: (json['page_tiers'] as List?)
              ?.map((e) =>
                  TierDefinition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userScoreWeights: _parseWeightMap(json['user_score_weights']),
      pageScoreWeights: _parseWeightMap(json['page_score_weights']),
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'evaluation_period_days': evaluationPeriodDays,
        'demotion_grace_period_days': demotionGracePeriodDays,
        'max_total_multiplier': maxTotalMultiplier,
        'user_tiers': userTiers.map((t) => t.toJson()).toList(),
        'page_tiers': pageTiers.map((t) => t.toJson()).toList(),
        'user_score_weights': userScoreWeights,
        'page_score_weights': pageScoreWeights,
      };
}

class TierDefinition {
  final String key;
  final String label;
  final double multiplier;
  final int minScore;
  final int maxScore;
  final String color;

  TierDefinition({
    this.key = '',
    this.label = '',
    this.multiplier = 1.0,
    this.minScore = 0,
    this.maxScore = 0,
    this.color = '',
  });

  factory TierDefinition.fromJson(Map<String, dynamic> json) {
    return TierDefinition(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      multiplier: (json['multiplier'] ?? 1.0).toDouble(),
      minScore: _safeInt(json['min_score']),
      maxScore: _safeInt(json['max_score']),
      color: json['color']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'label': label,
        'multiplier': multiplier,
        'min_score': minScore,
        'max_score': maxScore,
        'color': color,
      };
}

// ─────────────────────────────────────────────────
// Viral Config
// ─────────────────────────────────────────────────

class ViralConfig {
  final bool enabled;
  final int evaluationWindowHours;
  final int detectionIntervalHours;
  final bool applyToUsers;
  final bool applyToPages;
  final List<ViralThreshold> thresholds;

  ViralConfig({
    this.enabled = false,
    this.evaluationWindowHours = 24,
    this.detectionIntervalHours = 2,
    this.applyToUsers = true,
    this.applyToPages = true,
    this.thresholds = const [],
  });

  factory ViralConfig.fromJson(Map<String, dynamic> json) {
    return ViralConfig(
      enabled: json['enabled'] == true,
      evaluationWindowHours:
          _safeInt(json['evaluation_window_hours'], fallback: 24),
      detectionIntervalHours:
          _safeInt(json['detection_interval_hours'], fallback: 2),
      applyToUsers: json['apply_to_users'] != false,
      applyToPages: json['apply_to_pages'] != false,
      thresholds: (json['thresholds'] as List?)
              ?.map((e) =>
                  ViralThreshold.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'evaluation_window_hours': evaluationWindowHours,
        'detection_interval_hours': detectionIntervalHours,
        'apply_to_users': applyToUsers,
        'apply_to_pages': applyToPages,
        'thresholds': thresholds.map((t) => t.toJson()).toList(),
      };
}

class ViralThreshold {
  final String key;
  final String label;
  final double multiplier;
  final int minScore;
  final int maxScore;
  final int maxDurationHours;

  ViralThreshold({
    this.key = '',
    this.label = '',
    this.multiplier = 1.0,
    this.minScore = 0,
    this.maxScore = 0,
    this.maxDurationHours = 24,
  });

  factory ViralThreshold.fromJson(Map<String, dynamic> json) {
    return ViralThreshold(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      multiplier: (json['multiplier'] ?? 1.0).toDouble(),
      minScore: _safeInt(json['min_score']),
      maxScore: _safeInt(json['max_score']),
      maxDurationHours: _safeInt(json['max_duration_hours'], fallback: 24),
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'label': label,
        'multiplier': multiplier,
        'min_score': minScore,
        'max_score': maxScore,
        'max_duration_hours': maxDurationHours,
      };
}

// ─────────────────────────────────────────────────
// Anti-Abuse Config
// ─────────────────────────────────────────────────

class AntiAbuseConfig {
  final bool fakeDetectionEnabled;
  final int fakeScoreThreshold;
  final int autoFreezeThreshold;
  final String scanFrequency;

  AntiAbuseConfig({
    this.fakeDetectionEnabled = false,
    this.fakeScoreThreshold = 60,
    this.autoFreezeThreshold = 80,
    this.scanFrequency = 'daily',
  });

  factory AntiAbuseConfig.fromJson(Map<String, dynamic> json) {
    return AntiAbuseConfig(
      fakeDetectionEnabled: json['fake_detection_enabled'] == true,
      fakeScoreThreshold:
          _safeInt(json['fake_score_threshold'], fallback: 60),
      autoFreezeThreshold:
          _safeInt(json['auto_freeze_threshold'], fallback: 80),
      scanFrequency: json['scan_frequency']?.toString() ?? 'daily',
    );
  }

  Map<String, dynamic> toJson() => {
        'fake_detection_enabled': fakeDetectionEnabled,
        'fake_score_threshold': fakeScoreThreshold,
        'auto_freeze_threshold': autoFreezeThreshold,
        'scan_frequency': scanFrequency,
      };
}

// ─────────────────────────────────────────────────
// Shared helper
// ─────────────────────────────────────────────────

int _safeInt(dynamic v, {int fallback = 0}) {
  if (v == null) return fallback;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? fallback;
}
