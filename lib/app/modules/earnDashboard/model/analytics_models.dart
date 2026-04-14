/// Analytics data models for Phase 1 — Earning Analytics Dashboard

class DailyTrendPoint {
  final String date;
  final double earned;
  final double score;
  final int rank;

  DailyTrendPoint({
    required this.date,
    required this.earned,
    required this.score,
    required this.rank,
  });

  factory DailyTrendPoint.fromJson(Map<String, dynamic> json) {
    return DailyTrendPoint(
      date: json['date']?.toString() ?? '',
      earned: (json['earned'] ?? 0).toDouble(),
      score: (json['score'] ?? 0).toDouble(),
      rank: (json['rank'] ?? 0) is int ? json['rank'] : int.tryParse(json['rank'].toString()) ?? 0,
    );
  }
}

class DayHighlight {
  final String date;
  final double amount;

  DayHighlight({required this.date, required this.amount});

  factory DayHighlight.fromJson(Map<String, dynamic> json) {
    return DayHighlight(
      date: json['date']?.toString() ?? '',
      amount: (json['amount'] ?? json['earned'] ?? 0).toDouble(),
    );
  }
}

class EarningsTrendData {
  final List<DailyTrendPoint> dailyData;
  final double totalEarned;
  final double avgDaily;
  final DayHighlight? bestDay;
  final DayHighlight? worstDay;
  final String trend; // 'up' | 'down' | 'stable'
  final PeriodCompareData? periodCompare;

  EarningsTrendData({
    required this.dailyData,
    required this.totalEarned,
    required this.avgDaily,
    this.bestDay,
    this.worstDay,
    required this.trend,
    this.periodCompare,
  });

  factory EarningsTrendData.fromJson(Map<String, dynamic> json) {
    return EarningsTrendData(
      dailyData: (json['dailyData'] as List? ?? [])
          .map((e) => DailyTrendPoint.fromJson(e))
          .toList(),
      totalEarned: (json['totalEarned'] ?? 0).toDouble(),
      avgDaily: (json['avgDaily'] ?? 0).toDouble(),
      bestDay: json['bestDay'] != null
          ? DayHighlight.fromJson(json['bestDay'])
          : null,
      worstDay: json['worstDay'] != null
          ? DayHighlight.fromJson(json['worstDay'])
          : null,
      trend: json['trend']?.toString() ?? 'stable',
      periodCompare: json['periodCompare'] != null
          ? PeriodCompareData.fromJson(json['periodCompare'])
          : null,
    );
  }
}

class PeriodCompareData {
  final double currentTotal;
  final double previousTotal;
  final double changePercent;
  final String direction; // 'up' | 'down' | 'stable'
  final double currentEarned;
  final double previousEarned;
  final int currentPosts;
  final int previousPosts;
  final double currentAvgScore;
  final double previousAvgScore;

  PeriodCompareData({
    required this.currentTotal,
    required this.previousTotal,
    required this.changePercent,
    required this.direction,
    this.currentEarned = 0,
    this.previousEarned = 0,
    this.currentPosts = 0,
    this.previousPosts = 0,
    this.currentAvgScore = 0,
    this.previousAvgScore = 0,
  });

  factory PeriodCompareData.fromJson(Map<String, dynamic> json) {
    return PeriodCompareData(
      currentTotal: (json['currentTotal'] ?? 0).toDouble(),
      previousTotal: (json['previousTotal'] ?? 0).toDouble(),
      changePercent: (json['changePercent'] ?? 0).toDouble(),
      direction: json['direction']?.toString() ?? 'stable',
      currentEarned: (json['currentEarned'] ?? json['currentTotal'] ?? 0).toDouble(),
      previousEarned: (json['previousEarned'] ?? json['previousTotal'] ?? 0).toDouble(),
      currentPosts: (json['currentPosts'] ?? 0) is int ? (json['currentPosts'] ?? 0) : 0,
      previousPosts: (json['previousPosts'] ?? 0) is int ? (json['previousPosts'] ?? 0) : 0,
      currentAvgScore: (json['currentAvgScore'] ?? 0).toDouble(),
      previousAvgScore: (json['previousAvgScore'] ?? 0).toDouble(),
    );
  }
}

class ContentEarningEntry {
  final String postId;
  final String type; // 'post' | 'reel' | 'story'
  final String title;
  final int views;
  final int engagement;
  final double earned;
  final double score;

  ContentEarningEntry({
    required this.postId,
    required this.type,
    required this.title,
    required this.views,
    required this.engagement,
    required this.earned,
    this.score = 0,
  });

  factory ContentEarningEntry.fromJson(Map<String, dynamic> json) {
    return ContentEarningEntry(
      postId: json['postId']?.toString() ?? json['post_id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'post',
      title: json['title']?.toString() ?? '',
      views: (json['views'] ?? 0) is int
          ? json['views']
          : int.tryParse(json['views'].toString()) ?? 0,
      engagement: (json['engagement'] ?? 0) is int
          ? json['engagement']
          : int.tryParse(json['engagement'].toString()) ?? 0,
      earned: (json['earned'] ?? 0).toDouble(),
      score: (json['score'] ?? 0).toDouble(),
    );
  }
}

class WeekSummary {
  final int totalActivities;
  final int recommendedActivities;
  final double totalScore;
  final int activeDays;
  final double avgScore;
  final int totalPosts;
  final double totalEarned;
  final String bestDay;

  WeekSummary({
    required this.totalActivities,
    required this.recommendedActivities,
    required this.totalScore,
    required this.activeDays,
    this.avgScore = 0,
    this.totalPosts = 0,
    this.totalEarned = 0,
    this.bestDay = '',
  });

  factory WeekSummary.fromJson(Map<String, dynamic> json) {
    return WeekSummary(
      totalActivities: (json['totalActivities'] ?? json['total_activities'] ?? 0) as int,
      recommendedActivities: (json['recommendedActivities'] ?? json['recommended_activities'] ?? 100) as int,
      totalScore: (json['totalScore'] ?? json['total_score'] ?? 0).toDouble(),
      activeDays: (json['activeDays'] ?? json['active_days'] ?? 0) as int,
      avgScore: (json['avgScore'] ?? json['avg_score'] ?? 0).toDouble(),
      totalPosts: (json['totalPosts'] ?? json['total_posts'] ?? 0) is int ? (json['totalPosts'] ?? json['total_posts'] ?? 0) : 0,
      totalEarned: (json['totalEarned'] ?? json['total_earned'] ?? 0).toDouble(),
      bestDay: json['bestDay']?.toString() ?? json['best_day']?.toString() ?? '',
    );
  }
}

class StreakStatus {
  final int currentStreak;
  final int nextMilestone;
  final String nextMilestoneLabel;
  final double nextMilestoneBonus;
  final int bestStreak;
  final double multiplier;

  StreakStatus({
    required this.currentStreak,
    required this.nextMilestone,
    required this.nextMilestoneLabel,
    required this.nextMilestoneBonus,
    this.bestStreak = 0,
    this.multiplier = 1.0,
  });

  factory StreakStatus.fromJson(Map<String, dynamic> json) {
    return StreakStatus(
      currentStreak: (json['currentStreak'] ?? json['current_streak'] ?? 0) as int,
      nextMilestone: (json['nextMilestone'] ?? json['next_milestone'] ?? 7) as int,
      nextMilestoneLabel: json['nextMilestoneLabel']?.toString() ?? json['next_milestone_label']?.toString() ?? '7-Day Streak',
      nextMilestoneBonus: (json['nextMilestoneBonus'] ?? json['next_milestone_bonus'] ?? 0.10).toDouble(),
      bestStreak: (json['bestStreak'] ?? json['best_streak'] ?? 0) is int ? (json['bestStreak'] ?? json['best_streak'] ?? 0) : 0,
      multiplier: (json['multiplier'] ?? 1.0).toDouble(),
    );
  }
}

class Recommendation {
  final String priority; // 'high' | 'medium' | 'info'
  final String title;
  final String description;
  final String actionText;
  final String impact;

  Recommendation({
    required this.priority,
    required this.title,
    required this.description,
    required this.actionText,
    this.impact = '',
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      priority: json['priority']?.toString() ?? 'info',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      actionText: json['actionText']?.toString() ?? json['action_text']?.toString() ?? '',
      impact: json['impact']?.toString() ?? '',
    );
  }
}

class ActivityROI {
  final String activity;
  final int count;
  final double weight;
  final double totalPoints;
  final double percentOfTotal;
  final String insight;
  final double scoreImpact;
  final String effort;

  ActivityROI({
    required this.activity,
    required this.count,
    required this.weight,
    required this.totalPoints,
    required this.percentOfTotal,
    required this.insight,
    this.scoreImpact = 0,
    this.effort = '',
  });

  factory ActivityROI.fromJson(Map<String, dynamic> json) {
    return ActivityROI(
      activity: json['activity']?.toString() ?? '',
      count: (json['count'] ?? 0) as int,
      weight: (json['weight'] ?? 0).toDouble(),
      totalPoints: (json['totalPoints'] ?? json['total_points'] ?? 0).toDouble(),
      percentOfTotal: (json['percentOfTotal'] ?? json['percent_of_total'] ?? 0).toDouble(),
      insight: json['insight']?.toString() ?? '',
      scoreImpact: (json['scoreImpact'] ?? json['score_impact'] ?? json['totalPoints'] ?? 0).toDouble(),
      effort: json['effort']?.toString() ?? '',
    );
  }
}

class ScoreOptimizerData {
  final WeekSummary? weekSummary;
  final StreakStatus? streakStatus;
  final List<Recommendation> recommendations;
  final List<ActivityROI> activityROI;

  ScoreOptimizerData({
    this.weekSummary,
    this.streakStatus,
    required this.recommendations,
    required this.activityROI,
  });

  factory ScoreOptimizerData.fromJson(Map<String, dynamic> json) {
    return ScoreOptimizerData(
      weekSummary: json['weekSummary'] != null || json['week_summary'] != null
          ? WeekSummary.fromJson(json['weekSummary'] ?? json['week_summary'])
          : null,
      streakStatus: json['streakStatus'] != null || json['streak_status'] != null
          ? StreakStatus.fromJson(json['streakStatus'] ?? json['streak_status'])
          : null,
      recommendations: (json['recommendations'] as List? ?? [])
          .map((e) => Recommendation.fromJson(e))
          .toList(),
      activityROI: (json['activityROI'] as List? ?? json['activity_roi'] as List? ?? [])
          .map((e) => ActivityROI.fromJson(e))
          .toList(),
    );
  }
}

class EarningForecastData {
  final double projectedWeekly;
  final double projectedMonthly;
  final double confidence;
  final String trendDirection;
  final int basedOnDays;

  double get projected7d => projectedWeekly;
  double get projected30d => projectedMonthly;

  EarningForecastData({
    required this.projectedWeekly,
    required this.projectedMonthly,
    required this.confidence,
    required this.trendDirection,
    this.basedOnDays = 0,
  });

  factory EarningForecastData.fromJson(Map<String, dynamic> json) {
    return EarningForecastData(
      projectedWeekly: (json['projectedWeekly'] ?? json['projected_weekly'] ?? json['projected7d'] ?? 0).toDouble(),
      projectedMonthly: (json['projectedMonthly'] ?? json['projected_monthly'] ?? json['projected30d'] ?? 0).toDouble(),
      confidence: (json['confidence'] ?? 0).toDouble(),
      trendDirection: json['trendDirection']?.toString() ?? json['trend_direction']?.toString() ?? 'stable',
      basedOnDays: (json['basedOnDays'] ?? json['based_on_days'] ?? 0) is int ? (json['basedOnDays'] ?? json['based_on_days'] ?? 0) : 0,
    );
  }
}
