import 'package:flutter/material.dart';

/// Eligibility criteria item for page or creator monetization
class EligibilityCriteria {
  final String name; // 'followers', 'monthly_views', 'account_age', etc.
  final dynamic current;
  final dynamic required_;
  final bool met;

  EligibilityCriteria({
    required this.name,
    required this.current,
    required this.required_,
    required this.met,
  });

  factory EligibilityCriteria.fromJson(Map<String, dynamic> json) {
    return EligibilityCriteria(
      name: json['name'] ?? '',
      current: json['current'] ?? json['currentValue'] ?? 0,
      required_: json['required'] ?? json['requiredValue'] ?? json['required_'] ?? 0,
      met: json['met'] ?? false,
    );
  }
}

/// Page eligibility response
class PageEligibility {
  final bool isEligible;
  final List<EligibilityCriteria> criteria;
  final String message;

  PageEligibility({
    required this.isEligible,
    required this.criteria,
    required this.message,
  });

  factory PageEligibility.fromJson(Map<String, dynamic> json) {
    return PageEligibility(
      isEligible: json['isEligible'] ?? json['is_eligible'] ?? false,
      criteria: ((json['criteria'] ?? []) as List)
          .map((c) => EligibilityCriteria.fromJson(c))
          .toList(),
      message: json['message'] ?? '',
    );
  }
}

/// Page monetization application/status
class PageMonetizationStatus {
  final String status; // 'not_applied' | 'pending' | 'under_review' | 'approved' | 'rejected' | 'suspended'
  final String? reviewNote;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;

  PageMonetizationStatus({
    required this.status,
    this.reviewNote,
    this.submittedAt,
    this.reviewedAt,
  });

  factory PageMonetizationStatus.fromJson(Map<String, dynamic> json) {
    return PageMonetizationStatus(
      status: json['status'] ?? 'not_applied',
      reviewNote: json['reviewNote'] ?? json['review_note'],
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'].toString())
          : json['submitted_at'] != null
              ? DateTime.tryParse(json['submitted_at'].toString())
              : null,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.tryParse(json['reviewedAt'].toString())
          : json['reviewed_at'] != null
              ? DateTime.tryParse(json['reviewed_at'].toString())
              : null,
    );
  }
}

/// Dimension score for tier evaluation
class DimensionScore {
  final String name;
  final double score;
  final double weight;
  final double weightedScore;

  DimensionScore({
    required this.name,
    required this.score,
    required this.weight,
    required this.weightedScore,
  });

  factory DimensionScore.fromJson(Map<String, dynamic> json) {
    return DimensionScore(
      name: json['name'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      weightedScore: (json['weightedScore'] ?? json['weighted_score'] ?? 0).toDouble(),
    );
  }
}

/// Page tier info
class PageTierInfo {
  final String tierName;
  final double multiplier;
  final int priorityScore;
  final Map<String, DimensionScore> dimensions;
  final int nextTierThreshold;
  final int currentProgress;

  PageTierInfo({
    required this.tierName,
    required this.multiplier,
    required this.priorityScore,
    required this.dimensions,
    required this.nextTierThreshold,
    required this.currentProgress,
  });

  factory PageTierInfo.fromJson(Map<String, dynamic> json) {
    final dimMap = <String, DimensionScore>{};
    final rawDim = json['dimensions'] ?? {};
    if (rawDim is Map) {
      rawDim.forEach((k, v) {
        if (v is Map<String, dynamic>) {
          dimMap[k] = DimensionScore.fromJson(v);
        }
      });
    }
    return PageTierInfo(
      tierName: json['tierName'] ?? json['tier_name'] ?? 'Basic',
      multiplier: (json['multiplier'] ?? 1.0).toDouble(),
      priorityScore: json['priorityScore'] ?? json['priority_score'] ?? 0,
      dimensions: dimMap,
      nextTierThreshold: json['nextTierThreshold'] ?? json['next_tier_threshold'] ?? 0,
      currentProgress: json['currentProgress'] ?? json['current_progress'] ?? 0,
    );
  }
}

/// Viral content for a page
class PageViralContent {
  final String postId;
  final String status; // 'rising' | 'viral' | 'mega_viral' | 'expired'
  final int viralScore;
  final double bonusMultiplier;
  final double bonusEarnings;
  final int views;
  final int shares;
  final DateTime? detectedAt;

  PageViralContent({
    required this.postId,
    required this.status,
    required this.viralScore,
    required this.bonusMultiplier,
    required this.bonusEarnings,
    required this.views,
    required this.shares,
    this.detectedAt,
  });

  factory PageViralContent.fromJson(Map<String, dynamic> json) {
    return PageViralContent(
      postId: json['postId'] ?? json['post_id'] ?? '',
      status: json['status'] ?? 'rising',
      viralScore: json['viralScore'] ?? json['viral_score'] ?? 0,
      bonusMultiplier: (json['bonusMultiplier'] ?? json['bonus_multiplier'] ?? 1.0).toDouble(),
      bonusEarnings: (json['bonusEarnings'] ?? json['bonus_earnings'] ?? 0).toDouble(),
      views: json['views'] ?? 0,
      shares: json['shares'] ?? 0,
      detectedAt: json['detectedAt'] != null
          ? DateTime.tryParse(json['detectedAt'].toString())
          : json['detected_at'] != null
              ? DateTime.tryParse(json['detected_at'].toString())
              : null,
    );
  }
}

/// Risk signal
class RiskSignal {
  final String type;
  final String description;
  final String severity;

  RiskSignal({
    required this.type,
    required this.description,
    required this.severity,
  });

  factory RiskSignal.fromJson(Map<String, dynamic> json) {
    return RiskSignal(
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      severity: json['severity'] ?? 'low',
    );
  }
}

/// Page risk profile
class PageRiskProfile {
  final int riskScore;
  final String riskLevel;
  final List<RiskSignal> signals;
  final bool earningsFrozen;
  final DateTime? lastScanAt;

  PageRiskProfile({
    required this.riskScore,
    required this.riskLevel,
    required this.signals,
    required this.earningsFrozen,
    this.lastScanAt,
  });

  factory PageRiskProfile.fromJson(Map<String, dynamic> json) {
    return PageRiskProfile(
      riskScore: json['riskScore'] ?? json['risk_score'] ?? 0,
      riskLevel: json['riskLevel'] ?? json['risk_level'] ?? 'low',
      signals: ((json['signals'] ?? []) as List)
          .map((s) => RiskSignal.fromJson(s))
          .toList(),
      earningsFrozen: json['earningsFrozen'] ?? json['earnings_frozen'] ?? false,
      lastScanAt: json['lastScanAt'] != null
          ? DateTime.tryParse(json['lastScanAt'].toString())
          : json['last_scan_at'] != null
              ? DateTime.tryParse(json['last_scan_at'].toString())
              : null,
    );
  }
}

/// Tier history entry
class PageTierHistoryEntry {
  final String fromTier;
  final String toTier;
  final String action; // 'promotion' | 'demotion'
  final DateTime? date;
  final String reason;

  PageTierHistoryEntry({
    required this.fromTier,
    required this.toTier,
    required this.action,
    this.date,
    required this.reason,
  });

  factory PageTierHistoryEntry.fromJson(Map<String, dynamic> json) {
    return PageTierHistoryEntry(
      fromTier: json['fromTier'] ?? json['from_tier'] ?? '',
      toTier: json['toTier'] ?? json['to_tier'] ?? '',
      action: json['action'] ?? 'promotion',
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) : null,
      reason: json['reason'] ?? '',
    );
  }
}

/// Summary for page list
class PageMonetizationSummary {
  final String pageId;
  final String pageName;
  final String? profilePic;
  final String monetizationStatus; // 'active' | 'pending' | 'suspended' | 'none'
  final String? tierName;
  final double? multiplier;
  final int followers;

  PageMonetizationSummary({
    required this.pageId,
    required this.pageName,
    this.profilePic,
    required this.monetizationStatus,
    this.tierName,
    this.multiplier,
    required this.followers,
  });

  factory PageMonetizationSummary.fromJson(Map<String, dynamic> json) {
    return PageMonetizationSummary(
      pageId: json['pageId'] ?? json['page_id'] ?? json['_id'] ?? '',
      pageName: json['pageName'] ?? json['page_name'] ?? json['name'] ?? '',
      profilePic: json['profilePic'] ?? json['profile_pic'] ?? json['profileImage'],
      monetizationStatus: json['monetizationStatus'] ?? json['monetization_status'] ?? 'none',
      tierName: json['tierName'] ?? json['tier_name'],
      multiplier: json['multiplier'] != null ? (json['multiplier']).toDouble() : null,
      followers: json['followers'] ?? 0,
    );
  }

  /// Status dot color
  Color get statusColor {
    switch (monetizationStatus) {
      case 'active':
      case 'approved':
        return const Color(0xFF4CAF50); // green
      case 'pending':
      case 'under_review':
        return const Color(0xFFFFC107); // yellow
      case 'suspended':
      case 'rejected':
        return const Color(0xFFF44336); // red
      default:
        return const Color(0xFF9E9E9E); // gray
    }
  }
}
