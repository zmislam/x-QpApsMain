// Revenue Share Models — matches qp-web earning-dashboard API responses exactly

/// Helper class for score_breakdown sub-fields: each has {count, score}
class ActivityMetric {
  final int count;
  final double score;
  const ActivityMetric({this.count = 0, this.score = 0});

  factory ActivityMetric.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ActivityMetric(
        count: (json['count'] ?? 0) is int
            ? json['count'] ?? 0
            : int.tryParse((json['count'] ?? 0).toString()) ?? 0,
        score: (json['score'] ?? 0).toDouble(),
      );
    }
    // Fallback: if the value is a plain number, use it as count
    if (json is num) {
      return ActivityMetric(count: json.toInt(), score: 0);
    }
    return const ActivityMetric();
  }
}

class ScoreBreakdown {
  final ActivityMetric postReactionsReceived;
  final ActivityMetric postCommentsReceived;
  final ActivityMetric postSharesReceived;
  final ActivityMetric reelViewsReceived;
  final ActivityMetric storyViewsReceived;
  final ActivityMetric reactionsGiven;
  final ActivityMetric commentsGiven;
  final ActivityMetric sharesGiven;
  final ActivityMetric campaignImpressions;
  final ActivityMetric campaignClicks;
  final ActivityMetric campaignReactions;
  final ActivityMetric campaignComments;
  final ActivityMetric campaignShares;
  final ActivityMetric campaignWatch10sec;

  ScoreBreakdown({
    this.postReactionsReceived = const ActivityMetric(),
    this.postCommentsReceived = const ActivityMetric(),
    this.postSharesReceived = const ActivityMetric(),
    this.reelViewsReceived = const ActivityMetric(),
    this.storyViewsReceived = const ActivityMetric(),
    this.reactionsGiven = const ActivityMetric(),
    this.commentsGiven = const ActivityMetric(),
    this.sharesGiven = const ActivityMetric(),
    this.campaignImpressions = const ActivityMetric(),
    this.campaignClicks = const ActivityMetric(),
    this.campaignReactions = const ActivityMetric(),
    this.campaignComments = const ActivityMetric(),
    this.campaignShares = const ActivityMetric(),
    this.campaignWatch10sec = const ActivityMetric(),
  });

  factory ScoreBreakdown.fromJson(Map<String, dynamic> json) {
    return ScoreBreakdown(
      postReactionsReceived: ActivityMetric.fromJson(json['post_reactions_received']),
      postCommentsReceived: ActivityMetric.fromJson(json['post_comments_received']),
      postSharesReceived: ActivityMetric.fromJson(json['post_shares_received']),
      reelViewsReceived: ActivityMetric.fromJson(json['reel_views_received']),
      storyViewsReceived: ActivityMetric.fromJson(json['story_views_received']),
      reactionsGiven: ActivityMetric.fromJson(json['reactions_given']),
      commentsGiven: ActivityMetric.fromJson(json['comments_given']),
      sharesGiven: ActivityMetric.fromJson(json['shares_given']),
      campaignImpressions: ActivityMetric.fromJson(json['campaign_impressions']),
      campaignClicks: ActivityMetric.fromJson(json['campaign_clicks']),
      campaignReactions: ActivityMetric.fromJson(json['campaign_reactions']),
      campaignComments: ActivityMetric.fromJson(json['campaign_comments']),
      campaignShares: ActivityMetric.fromJson(json['campaign_shares']),
      campaignWatch10sec: ActivityMetric.fromJson(json['campaign_watch_10sec']),
    );
  }
}

class CountdownData {
  final String nextDistribution;
  final String serverTime;
  final bool distributionCompletedToday;

  CountdownData({
    this.nextDistribution = '',
    this.serverTime = '',
    this.distributionCompletedToday = false,
  });

  factory CountdownData.fromJson(Map<String, dynamic> json) {
    return CountdownData(
      nextDistribution: json['next_distribution']?.toString() ?? '',
      serverTime: json['server_time']?.toString() ?? '',
      distributionCompletedToday: json['distribution_completed_today'] == true,
    );
  }
}

class TodayEstimateModel {
  final double estimatedEarning;
  final double currentScore;
  final int rank;
  final int totalUsers;
  final double percentile;
  final bool distributionCompleted;
  final ScoreBreakdown? scoreBreakdown;
  final int streakDays;
  final double bonusMultiplier;
  final CountdownData? countdown;

  TodayEstimateModel({
    this.estimatedEarning = 0,
    this.currentScore = 0,
    this.rank = 0,
    this.totalUsers = 0,
    this.percentile = 0,
    this.distributionCompleted = false,
    this.scoreBreakdown,
    this.streakDays = 0,
    this.bonusMultiplier = 1.0,
    this.countdown,
  });

  factory TodayEstimateModel.fromJson(Map<String, dynamic> json) {
    return TodayEstimateModel(
      estimatedEarning: (json['estimated_earning'] ?? 0).toDouble(),
      currentScore: (json['current_score'] ?? 0).toDouble(),
      rank: _safeInt(json['rank'], fallback: 0),
      totalUsers: _safeInt(json['total_users'], fallback: 0),
      percentile: (json['percentile'] ?? 0).toDouble(),
      distributionCompleted: json['distribution_completed'] == true,
      scoreBreakdown: json['score_breakdown'] != null
          ? ScoreBreakdown.fromJson(json['score_breakdown'])
          : null,
      streakDays: _safeInt(json['streak_days'], fallback: 0),
      bonusMultiplier: (json['bonus_multiplier'] ?? 1.0).toDouble(),
      countdown: json['countdown'] != null
          ? CountdownData.fromJson(json['countdown'])
          : null,
    );
  }
}

// --- Wallet ---

class WithdrawalEntry {
  final double amountDollars;
  final String requestedAt;
  final String status;

  WithdrawalEntry({
    this.amountDollars = 0,
    this.requestedAt = '',
    this.status = '',
  });

  factory WithdrawalEntry.fromJson(Map<String, dynamic> json) {
    return WithdrawalEntry(
      amountDollars: (json['amountDollars'] ?? json['amount_dollars'] ?? 0).toDouble(),
      requestedAt: json['requestedAt']?.toString() ?? json['requested_at']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}

class WalletSummaryModel {
  final bool hasStripeAccount;
  final bool isStripeActive;
  final bool isWithdrawalReady;
  final bool isInCooldown;
  final bool canWithdraw;
  final double availableBalanceDollars;
  final int availableBalanceCents;
  final double lifetimeEarningsDollars;
  final double completedWithdrawalsDollars;
  final double amountUntilWithdrawalDollars;
  final int pendingWithdrawalsCount;
  final double pendingWithdrawalsDollars;
  final List<WithdrawalEntry> recentWithdrawals;

  WalletSummaryModel({
    this.hasStripeAccount = false,
    this.isStripeActive = false,
    this.isWithdrawalReady = false,
    this.isInCooldown = false,
    this.canWithdraw = false,
    this.availableBalanceDollars = 0,
    this.availableBalanceCents = 0,
    this.lifetimeEarningsDollars = 0,
    this.completedWithdrawalsDollars = 0,
    this.amountUntilWithdrawalDollars = 0,
    this.pendingWithdrawalsCount = 0,
    this.pendingWithdrawalsDollars = 0,
    this.recentWithdrawals = const [],
  });

  factory WalletSummaryModel.fromJson(Map<String, dynamic> json) {
    return WalletSummaryModel(
      hasStripeAccount: json['hasStripeAccount'] == true,
      isStripeActive: json['isStripeActive'] == true,
      isWithdrawalReady: json['isWithdrawalReady'] == true,
      isInCooldown: json['isInCooldown'] == true,
      canWithdraw: json['canWithdraw'] == true,
      availableBalanceDollars: double.tryParse(json['availableBalanceDollars']?.toString() ?? '0') ?? 0,
      availableBalanceCents: (json['availableBalanceCents'] ?? 0) is int ? (json['availableBalanceCents'] ?? 0) : int.tryParse(json['availableBalanceCents']?.toString() ?? '0') ?? 0,
      lifetimeEarningsDollars: double.tryParse(json['lifetimeEarningsDollars']?.toString() ?? '0') ?? 0,
      completedWithdrawalsDollars: double.tryParse(json['completedWithdrawalsDollars']?.toString() ?? '0') ?? 0,
      amountUntilWithdrawalDollars: double.tryParse(json['amountUntilWithdrawalDollars']?.toString() ?? '0') ?? 0,
      pendingWithdrawalsCount: (json['pendingWithdrawalsCount'] ?? 0) is int ? (json['pendingWithdrawalsCount'] ?? 0) : int.tryParse(json['pendingWithdrawalsCount']?.toString() ?? '0') ?? 0,
      pendingWithdrawalsDollars: double.tryParse(json['pendingWithdrawalsDollars']?.toString() ?? '0') ?? 0,
      recentWithdrawals: (json['recentWithdrawals'] as List?)
              ?.map((e) => WithdrawalEntry.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// --- Page Breakdown ---

class ActivityBreakdown {
  final int postReactionsReceived;
  final int postCommentsReceived;
  final int postSharesReceived;
  final int reelViewsReceived;
  final int storyViewsReceived;
  final int reactionsGiven;
  final int commentsGiven;
  final int sharesGiven;
  final int campaignImpressions;
  final int campaignClicks;
  final int campaignReactions;
  final int campaignComments;
  final int campaignShares;
  final int campaignWatch10sec;

  ActivityBreakdown({
    this.postReactionsReceived = 0,
    this.postCommentsReceived = 0,
    this.postSharesReceived = 0,
    this.reelViewsReceived = 0,
    this.storyViewsReceived = 0,
    this.reactionsGiven = 0,
    this.commentsGiven = 0,
    this.sharesGiven = 0,
    this.campaignImpressions = 0,
    this.campaignClicks = 0,
    this.campaignReactions = 0,
    this.campaignComments = 0,
    this.campaignShares = 0,
    this.campaignWatch10sec = 0,
  });

  factory ActivityBreakdown.fromJson(Map<String, dynamic> json) {
    return ActivityBreakdown(
      postReactionsReceived: _safeInt(json['post_reactions_received'], fallback: 0),
      postCommentsReceived: _safeInt(json['post_comments_received'], fallback: 0),
      postSharesReceived: _safeInt(json['post_shares_received'], fallback: 0),
      reelViewsReceived: _safeInt(json['reel_views_received'], fallback: 0),
      storyViewsReceived: _safeInt(json['story_views_received'], fallback: 0),
      reactionsGiven: _safeInt(json['reactions_given'], fallback: 0),
      commentsGiven: _safeInt(json['comments_given'], fallback: 0),
      sharesGiven: _safeInt(json['shares_given'], fallback: 0),
      campaignImpressions: _safeInt(json['campaign_impressions'], fallback: 0),
      campaignClicks: _safeInt(json['campaign_clicks'], fallback: 0),
      campaignReactions: _safeInt(json['campaign_reactions'], fallback: 0),
      campaignComments: _safeInt(json['campaign_comments'], fallback: 0),
      campaignShares: _safeInt(json['campaign_shares'], fallback: 0),
      campaignWatch10sec: _safeInt(json['campaign_watch_10sec'], fallback: 0),
    );
  }
}

class PageBreakdownEntry {
  final String id;
  final String type; // "personal" or "page"
  final String name;
  final String username;
  final String profilePic;
  final double score;
  final double rawScore;
  final int streakDays;
  final double bonusMultiplier;
  final ActivityBreakdown? activities;

  PageBreakdownEntry({
    this.id = '',
    this.type = '',
    this.name = '',
    this.username = '',
    this.profilePic = '',
    this.score = 0,
    this.rawScore = 0,
    this.streakDays = 0,
    this.bonusMultiplier = 1.0,
    this.activities,
  });

  factory PageBreakdownEntry.fromJson(Map<String, dynamic> json) {
    return PageBreakdownEntry(
      id: json['_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString() ?? '',
      score: (json['score'] ?? 0).toDouble(),
      rawScore: (json['raw_score'] ?? 0).toDouble(),
      streakDays: _safeInt(json['streak_days'], fallback: 0),
      bonusMultiplier: (json['bonus_multiplier'] ?? 1.0).toDouble(),
      activities: json['activities'] != null
          ? ActivityBreakdown.fromJson(json['activities'])
          : null,
    );
  }
}

// --- Leaderboard ---

class LeaderboardUser {
  final String id;
  final String name;
  final String username;
  final String profilePicture;

  LeaderboardUser({
    this.id = '',
    this.name = '',
    this.username = '',
    this.profilePicture = '',
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      profilePicture: json['profile_picture']?.toString() ?? '',
    );
  }
}

class LeaderboardEntry {
  final int rank;
  final LeaderboardUser? user;
  final double score;
  final bool isCurrentUser;

  LeaderboardEntry({
    this.rank = 0,
    this.user,
    this.score = 0,
    this.isCurrentUser = false,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: _safeInt(json['rank'], fallback: 0),
      user: json['user'] != null ? LeaderboardUser.fromJson(json['user']) : null,
      score: (json['score'] ?? 0).toDouble(),
      isCurrentUser: json['isCurrentUser'] == true,
    );
  }
}

class LeaderboardSummary {
  final int totalUsersWithScore;
  final double topScore;

  LeaderboardSummary({
    this.totalUsersWithScore = 0,
    this.topScore = 0,
  });

  factory LeaderboardSummary.fromJson(Map<String, dynamic> json) {
    return LeaderboardSummary(
      totalUsersWithScore: _safeInt(json['total_users_with_score'], fallback: 0),
      topScore: (json['top_score'] ?? 0).toDouble(),
    );
  }
}

// --- Score Weights ---

class ScoreWeightsModel {
  final double revenueSharePercentage;
  final Map<String, double> scoreWeights;
  final Map<String, dynamic> bonusMultipliers;
  final Map<String, dynamic> description;

  ScoreWeightsModel({
    this.revenueSharePercentage = 0,
    this.scoreWeights = const {},
    this.bonusMultipliers = const {},
    this.description = const {},
  });

  factory ScoreWeightsModel.fromJson(Map<String, dynamic> json) {
    final sw = json['score_weights'];
    Map<String, double> parsedWeights = {};
    if (sw is Map) {
      sw.forEach((key, value) {
        parsedWeights[key.toString()] = (value ?? 0).toDouble();
      });
    }
    return ScoreWeightsModel(
      revenueSharePercentage: (json['revenue_share_percentage'] ?? 0).toDouble(),
      scoreWeights: parsedWeights,
      bonusMultipliers: (json['bonus_multipliers'] as Map<String, dynamic>?) ?? {},
      description: (json['description'] as Map<String, dynamic>?) ?? {},
    );
  }
}

// --- Daily Earnings ---

class DailyEarningEntry {
  final String date;
  final double amount;
  final double score;
  final double finalScore;
  final int rank;
  final double percentile;
  final double bonusMultiplier;
  final double streakBonus;
  final double verifiedBonus;
  final double otherBonus;
  final String status;
  final String reason;

  DailyEarningEntry({
    this.date = '',
    this.amount = 0,
    this.score = 0,
    this.finalScore = 0,
    this.rank = 0,
    this.percentile = 0,
    this.bonusMultiplier = 1.0,
    this.streakBonus = 0,
    this.verifiedBonus = 0,
    this.otherBonus = 0,
    this.status = '',
    this.reason = '',
  });

  factory DailyEarningEntry.fromJson(Map<String, dynamic> json) {
    final bonus = json['bonus_details'];
    return DailyEarningEntry(
      date: json['date']?.toString() ?? '',
      amount: (json['amount'] ?? json['earning_amount'] ?? 0).toDouble(),
      score: (json['score'] ?? json['total_score'] ?? 0).toDouble(),
      finalScore: (json['final_score'] ?? json['score'] ?? json['total_score'] ?? 0).toDouble(),
      rank: (json['rank'] ?? json['daily_rank'] ?? 0) is int
          ? (json['rank'] ?? json['daily_rank'] ?? 0)
          : int.tryParse((json['rank'] ?? json['daily_rank'] ?? 0).toString()) ?? 0,
      percentile: (json['percentile'] ?? 0).toDouble(),
      bonusMultiplier: (json['bonus_multiplier'] ?? 1.0).toDouble(),
      streakBonus: bonus is Map ? (bonus['streak_bonus'] ?? 0).toDouble() : 0,
      verifiedBonus: bonus is Map ? (bonus['verified_bonus'] ?? 0).toDouble() : 0,
      otherBonus: bonus is Map ? (bonus['other_bonus'] ?? 0).toDouble() : 0,
      status: json['status']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
    );
  }
}

class BestDayInfo {
  final String date;
  final double amount;

  BestDayInfo({this.date = '', this.amount = 0});

  factory BestDayInfo.fromJson(Map<String, dynamic> json) {
    return BestDayInfo(
      date: json['date']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}

class DailyEarningsSummary {
  final double totalEarned;
  final double totalScore;
  final double avgEarning;
  final double bestDayAmount;

  DailyEarningsSummary({
    this.totalEarned = 0,
    this.totalScore = 0,
    this.avgEarning = 0,
    this.bestDayAmount = 0,
  });

  factory DailyEarningsSummary.fromJson(Map<String, dynamic> json) {
    double bestDay = 0;
    final bd = json['best_day'];
    if (bd is Map<String, dynamic>) {
      bestDay = (bd['amount'] ?? bd['earning_amount'] ?? 0).toDouble();
    } else if (bd is num) {
      bestDay = bd.toDouble();
    }
    return DailyEarningsSummary(
      totalEarned: (json['total_earned'] ?? 0).toDouble(),
      totalScore: (json['total_score'] ?? 0).toDouble(),
      avgEarning: (json['avg_earning'] ?? json['average_earning'] ?? 0).toDouble(),
      bestDayAmount: bestDay,
    );
  }
}

class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int pages;

  PaginationMeta({
    this.page = 1,
    this.limit = 10,
    this.total = 0,
    this.pages = 0,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: _safeInt(json['page'], fallback: 1),
      limit: _safeInt(json['limit'], fallback: 10),
      total: _safeInt(json['total'], fallback: 0),
      pages: _safeInt(json['pages'], fallback: 0),
    );
  }
}

// --- Daily Breakdown ---

class DistributionInfo {
  final double totalAdRevenue;
  final double creatorPool;
  final int totalUsersPaid;

  DistributionInfo({
    this.totalAdRevenue = 0,
    this.creatorPool = 0,
    this.totalUsersPaid = 0,
  });

  factory DistributionInfo.fromJson(Map<String, dynamic> json) {
    return DistributionInfo(
      totalAdRevenue: (json['total_ad_revenue'] ?? 0).toDouble(),
      creatorPool: (json['creator_pool'] ?? 0).toDouble(),
      totalUsersPaid: _safeInt(json['total_users_paid']),
    );
  }
}

int _safeInt(dynamic v, {int fallback = 0}) {
  if (v == null) return fallback;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? fallback;
}

class DailyBreakdownModel {
  final String date;
  final ScoreBreakdown? scoreBreakdown;
  final double totalScore;
  final double bonusMultiplier;
  final Map<String, dynamic> bonusDetails;
  final double finalScore;
  final double poolPercentage;
  final double totalPool;
  final double pointValue;
  final double earningAmount;
  final int dailyRank;
  final double percentile;
  final String status;
  final String reason;
  final DistributionInfo? distributionInfo;

  DailyBreakdownModel({
    this.date = '',
    this.scoreBreakdown,
    this.totalScore = 0,
    this.bonusMultiplier = 1.0,
    this.bonusDetails = const {},
    this.finalScore = 0,
    this.poolPercentage = 0,
    this.totalPool = 0,
    this.pointValue = 0,
    this.earningAmount = 0,
    this.dailyRank = 0,
    this.percentile = 0,
    this.status = '',
    this.reason = '',
    this.distributionInfo,
  });

  factory DailyBreakdownModel.fromJson(Map<String, dynamic> json) {
    return DailyBreakdownModel(
      date: json['date']?.toString() ?? '',
      scoreBreakdown: json['score_breakdown'] != null
          ? ScoreBreakdown.fromJson(json['score_breakdown'])
          : null,
      totalScore: (json['total_score'] ?? 0).toDouble(),
      bonusMultiplier: (json['bonus_multiplier'] ?? 1.0).toDouble(),
      bonusDetails: (json['bonus_details'] as Map<String, dynamic>?) ?? {},
      finalScore: (json['final_score'] ?? 0).toDouble(),
      poolPercentage: (json['pool_percentage'] ?? 0).toDouble(),
      totalPool: (json['total_pool'] ?? 0).toDouble(),
      pointValue: (json['point_value'] ?? 0).toDouble(),
      earningAmount: (json['earning_amount'] ?? 0).toDouble(),
      dailyRank: _safeInt(json['daily_rank']),
      percentile: (json['percentile'] ?? 0).toDouble(),
      status: json['status']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      distributionInfo: json['distribution_info'] != null
          ? DistributionInfo.fromJson(json['distribution_info'])
          : null,
    );
  }
}

// --- Platform Stats ---

class DistributionDay {
  final String date;
  final double totalAdRevenue;
  final double creatorPool;
  final int usersPaid;
  final double averageEarning;
  final double pointValue;

  DistributionDay({
    this.date = '',
    this.totalAdRevenue = 0,
    this.creatorPool = 0,
    this.usersPaid = 0,
    this.averageEarning = 0,
    this.pointValue = 0,
  });

  factory DistributionDay.fromJson(Map<String, dynamic> json) {
    return DistributionDay(
      date: json['date']?.toString() ?? '',
      totalAdRevenue: (json['total_ad_revenue'] ?? 0).toDouble(),
      creatorPool: (json['creator_pool'] ?? 0).toDouble(),
      usersPaid: _safeInt(json['users_paid'], fallback: 0),
      averageEarning: (json['average_earning'] ?? 0).toDouble(),
      pointValue: (json['point_value'] ?? 0).toDouble(),
    );
  }
}

class MonthlySummary {
  final double totalRevenue;
  final double totalCreatorPool;
  final int totalUsersPaid;
  final double avgDailyPool;
  final double avgDailyEarning;
  final int distributionDays;

  MonthlySummary({
    this.totalRevenue = 0,
    this.totalCreatorPool = 0,
    this.totalUsersPaid = 0,
    this.avgDailyPool = 0,
    this.avgDailyEarning = 0,
    this.distributionDays = 0,
  });

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      totalCreatorPool: (json['total_creator_pool'] ?? 0).toDouble(),
      totalUsersPaid: _safeInt(json['total_users_paid']),
      avgDailyPool: (json['avg_daily_pool'] ?? 0).toDouble(),
      avgDailyEarning: (json['avg_daily_earning'] ?? 0).toDouble(),
      distributionDays: _safeInt(json['distribution_days']),
    );
  }
}

class PlatformStatsModel {
  final double revenueSharePercentage;
  final List<DistributionDay> recentDistributions;
  final MonthlySummary? monthlySummary;
  final int totalCreatorsEarning;
  final Map<String, dynamic> scoreWeights;

  PlatformStatsModel({
    this.revenueSharePercentage = 0,
    this.recentDistributions = const [],
    this.monthlySummary,
    this.totalCreatorsEarning = 0,
    this.scoreWeights = const {},
  });

  factory PlatformStatsModel.fromJson(Map<String, dynamic> json) {
    return PlatformStatsModel(
      revenueSharePercentage: (json['revenue_share_percentage'] ?? 0).toDouble(),
      recentDistributions: (json['recent_distributions'] as List?)
              ?.map((e) => DistributionDay.fromJson(e))
              .toList() ??
          [],
      monthlySummary: json['monthly_summary'] != null
          ? MonthlySummary.fromJson(json['monthly_summary'])
          : null,
      totalCreatorsEarning: _safeInt(json['total_creators_earning'], fallback: 0),
      scoreWeights: (json['score_weights'] as Map<String, dynamic>?) ?? {},
    );
  }
}
