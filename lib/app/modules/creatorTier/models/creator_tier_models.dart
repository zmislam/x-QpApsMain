import '../../../modules/pageMonetization/models/page_monetization_models.dart';

/// Creator tier info from /api/creator/my-tier
class CreatorTierInfo {
  final String tierName;
  final double multiplier;
  final int priorityScore;
  final Map<String, DimensionScore> dimensions;
  final String nextTier;
  final int nextTierThreshold;
  final int currentProgress;

  CreatorTierInfo({
    required this.tierName,
    required this.multiplier,
    required this.priorityScore,
    required this.dimensions,
    required this.nextTier,
    required this.nextTierThreshold,
    required this.currentProgress,
  });

  factory CreatorTierInfo.fromJson(Map<String, dynamic> json) {
    final dimMap = <String, DimensionScore>{};
    final rawDim = json['dimensions'] ?? {};
    if (rawDim is Map) {
      rawDim.forEach((k, v) {
        if (v is Map<String, dynamic>) {
          dimMap[k] = DimensionScore.fromJson(v);
        }
      });
    }
    return CreatorTierInfo(
      tierName: json['tierName'] ?? json['tier_name'] ?? 'Starter',
      multiplier: (json['multiplier'] ?? 1.0).toDouble(),
      priorityScore: json['priorityScore'] ?? json['priority_score'] ?? 0,
      dimensions: dimMap,
      nextTier: json['nextTier'] ?? json['next_tier'] ?? '',
      nextTierThreshold: json['nextTierThreshold'] ?? json['next_tier_threshold'] ?? 0,
      currentProgress: json['currentProgress'] ?? json['current_progress'] ?? 0,
    );
  }
}

/// Creator eligibility check
class CreatorEligibility {
  final bool isEligible;
  final List<EligibilityCriteria> criteria;

  CreatorEligibility({
    required this.isEligible,
    required this.criteria,
  });

  factory CreatorEligibility.fromJson(Map<String, dynamic> json) {
    return CreatorEligibility(
      isEligible: json['isEligible'] ?? json['is_eligible'] ?? false,
      criteria: ((json['criteria'] ?? []) as List)
          .map((c) => EligibilityCriteria.fromJson(c))
          .toList(),
    );
  }
}

/// Creator application
class CreatorApplication {
  final String status; // 'not_applied' | 'pending' | 'approved' | 'rejected'
  final DateTime? appliedAt;
  final DateTime? reviewedAt;
  final String? reason;

  CreatorApplication({
    required this.status,
    this.appliedAt,
    this.reviewedAt,
    this.reason,
  });

  factory CreatorApplication.fromJson(Map<String, dynamic> json) {
    return CreatorApplication(
      status: json['status'] ?? 'not_applied',
      appliedAt: json['appliedAt'] != null
          ? DateTime.tryParse(json['appliedAt'].toString())
          : json['applied_at'] != null
              ? DateTime.tryParse(json['applied_at'].toString())
              : null,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.tryParse(json['reviewedAt'].toString())
          : json['reviewed_at'] != null
              ? DateTime.tryParse(json['reviewed_at'].toString())
              : null,
      reason: json['reason'],
    );
  }
}

/// Priority score breakdown
class PriorityScoreBreakdown {
  final int totalScore;
  final Map<String, DimensionDetail> dimensions;

  PriorityScoreBreakdown({
    required this.totalScore,
    required this.dimensions,
  });

  factory PriorityScoreBreakdown.fromJson(Map<String, dynamic> json) {
    final dMap = <String, DimensionDetail>{};
    final rawDim = json['dimensions'] ?? {};
    if (rawDim is Map) {
      rawDim.forEach((k, v) {
        if (v is Map<String, dynamic>) {
          dMap[k] = DimensionDetail.fromJson(v);
        }
      });
    }
    return PriorityScoreBreakdown(
      totalScore: json['totalScore'] ?? json['total_score'] ?? 0,
      dimensions: dMap,
    );
  }
}

class DimensionDetail {
  final String name;
  final double weight;
  final double rawScore;
  final double weightedScore;
  final String? tip;

  DimensionDetail({
    required this.name,
    required this.weight,
    required this.rawScore,
    required this.weightedScore,
    this.tip,
  });

  factory DimensionDetail.fromJson(Map<String, dynamic> json) {
    return DimensionDetail(
      name: json['name'] ?? '',
      weight: (json['weight'] ?? 0).toDouble(),
      rawScore: (json['rawScore'] ?? json['raw_score'] ?? 0).toDouble(),
      weightedScore: (json['weightedScore'] ?? json['weighted_score'] ?? 0).toDouble(),
      tip: json['tip'],
    );
  }
}

/// Tier change history entry
class TierHistoryEntry {
  final String fromTier;
  final String toTier;
  final String action; // 'promotion' | 'demotion'
  final DateTime? date;
  final String reason;

  TierHistoryEntry({
    required this.fromTier,
    required this.toTier,
    required this.action,
    this.date,
    required this.reason,
  });

  factory TierHistoryEntry.fromJson(Map<String, dynamic> json) {
    return TierHistoryEntry(
      fromTier: json['fromTier'] ?? json['from_tier'] ?? '',
      toTier: json['toTier'] ?? json['to_tier'] ?? '',
      action: json['action'] ?? 'promotion',
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) : null,
      reason: json['reason'] ?? '',
    );
  }
}
