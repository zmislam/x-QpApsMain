# QP Mobile App — Web Feature Parity Implementation Plan

## User Profile & Page Sections — Comprehensive Gap Analysis & Implementation Roadmap

**Created:** April 13, 2026  
**Updated:** April 13, 2026 (v2 — Dynamic Config Alignment)  
**Project:** x-QpApsMain (Flutter)  
**Reference:** qp-web (Next.js)  
**Backend:** qp-api (Node.js/Express) — All APIs already exist  
**Admin Config:** qp-admin (earning-config with RevenueShareConfig)  
**Status:** ⬜ Not Started

---

## TABLE OF CONTENTS

1. [Executive Summary](#1-executive-summary)
2. [Gap Analysis — Complete Feature Matrix](#2-gap-analysis)
3. [**Phase 0 — Dynamic Config Foundation (CRITICAL)**](#phase-0)
4. [Phase 1 — Earning Analytics Dashboard](#phase-1)
5. [Phase 2 — Page Monetization System](#phase-2)
6. [Phase 3 — Creator Tier System](#phase-3)
7. [Phase 4 — Viral Content System](#phase-4)
8. [Phase 5 — Anti-Abuse & Risk System](#phase-5)
9. [Phase 6 — Tipping & Donations System](#phase-6)
10. [Phase 7 — Profile & Page Badge Integration](#phase-7)
11. [Phase 8 — Wallet Enhancements](#phase-8)
12. [Architecture & Technical Guidelines](#architecture)
13. [API Endpoint Reference](#api-reference)
14. [Testing Strategy](#testing)
15. [Rollout Plan](#rollout)

---

## 1. EXECUTIVE SUMMARY <a id="1-executive-summary"></a>

### Current State

| Area | qp-web | Mobile | Gap |
|------|--------|--------|-----|
| **Basic Earning Dashboard** | ✅ Complete | ✅ Complete | Aligned |
| **Earning Rulebook/Guide** | ✅ 11 sections (DYNAMIC) | ⚠️ 8 sections (STATIC) | **CRITICAL GAP** |
| **Wallet & Stripe** | ✅ Complete | ✅ Complete | Aligned |
| **Leaderboard** | ✅ Auto-refresh | ✅ Auto-refresh | Aligned |
| **Earning Analytics** | ✅ 6 components | ❌ Missing | **MAJOR GAP** |
| **Page Monetization** | ✅ Full (Phase A-H) | ❌ Missing | **MAJOR GAP** |
| **Creator Tier System** | ✅ 7 components | ❌ Missing | **MAJOR GAP** |
| **Viral Content System** | ⚠️ Backup (not merged) | ❌ Missing | **GAP** |
| **Tipping System** | ⚠️ Backup (not merged) | ❌ Missing | **GAP** |
| **Anti-Abuse UI** | ✅ 6 components | ❌ Missing | **MAJOR GAP** |
| **Profile Earning Badge** | ✅ Integrated | ⚠️ Basic only | **GAP** |
| **Page Tier Badges** | ✅ Integrated | ❌ Missing | **MAJOR GAP** |
| **Earning Summary on Profile** | ✅ Eligibility banner | ⚠️ Basic status | **GAP** |

### What's Already Aligned ✅
- Core earning dashboard (TodayEstimate, WalletBalance, ScoreBreakdown, Leaderboard, ScoreWeights, EarningHistory, PlatformStats)
- Stripe wallet connect & withdrawal flow
- Revenue share models matching backend response structure
- All backend API endpoints already exist — no backend work needed

### ⚠️ CRITICAL: Dynamic Config Gap (Static vs Dynamic)
qp-web loads **ALL configuration from the admin backend API** (`/api/earning/score-weights` → `RevenueShareConfig` model). When admin changes any config in qp-admin, the web UI reflects changes immediately. **Mobile currently has HARDCODED values** in the earning guide — this must be fixed FIRST before any new features.

| Data | qp-web | Mobile | Issue |
|------|--------|--------|-------|
| Score weights (point values per activity) | ✅ Dynamic from API | ❌ Hardcoded in `earning_guide_view.dart` | Admin changes won't reflect |
| Bonus multipliers (streak 7/30/90d %) | ✅ Dynamic from API | ❌ Hardcoded "+10%", "+25%", "+50%" | Admin changes won't reflect |
| Revenue share percentage | ✅ Dynamic from API | ❌ Hardcoded "50/50" | Admin changes won't reflect |
| Streak tier thresholds (7/30/90 days) | ✅ Dynamic from API | ❌ Hardcoded | Admin changes won't reflect |
| Eligibility criteria | ✅ Dynamic from API | ❌ Hardcoded | Admin changes won't reflect |
| Distribution time / mode | ✅ Dynamic from API | ❌ Hardcoded "12 AM UTC" | Admin changes won't reflect |
| Tier config (names, multipliers, thresholds) | ✅ Dynamic from API | N/A (not built yet) | Must be dynamic from start |
| Viral config (thresholds, multipliers, durations) | ✅ Dynamic from API | N/A (not built yet) | Must be dynamic from start |
| Page monetization rules | ✅ Dynamic from API | N/A (not built yet) | Must be dynamic from start |
| Page anti-abuse thresholds | ✅ Dynamic from API | N/A (not built yet) | Must be dynamic from start |

### What's Missing ❌
- **6 Earning Analytics screens** (trends, period compare, rank tracker, content earnings, score optimizer, forecast)
- **8 Page Monetization screens** (eligibility, application, status, tier badge, tier progress, viral history, risk indicator, earning overview)
- **7 Creator Tier screens** (tier badge, tier progress, eligibility card, application form, application status, priority score breakdown, tier history)
- **8+ Viral Content screens** (viral badge, rising badge, score breakdown, bonus toast, trending card/feed, my viral posts)
- **6 Anti-Abuse screens** (warning banner, frozen banner, account standing, appeal form, duplicate warning, rate limit)
- **11 Tipping screens** (tip button, tip modal, tip animation, toast, supporters, goal progress, goal form, history, summary card, supporter badge)
- **Profile integration badges** (creator tier badge, earning summary badge, page tier indicators)

---

## 2. GAP ANALYSIS — COMPLETE FEATURE MATRIX <a id="2-gap-analysis"></a>

### A. User Profile Section

| Feature | Web Component | Web Location | Mobile Equivalent | Status |
|---------|--------------|--------------|-------------------|--------|
| Profile earning status indicator | `ProfileComponent.jsx` earningBanner | EarningDashboard/ | `profile_view.dart` basic status | ⚠️ Partial |
| Creator tier badge on profile | `CreatorTierBadge.jsx` | Creator/ | — | ❌ Missing |
| Earning summary mini-card | Eligibility card in profile | EarningDashboard/ | — | ❌ Missing |
| Verified creator badge + bonus label | In TodayEstimateCard | RevenueShare/ | Basic streak label only | ⚠️ Partial |
| "View Earnings" profile CTA | Profile → Earning Dashboard link | Profile/ | Earn button exists | ✅ Exists |
| Creator tier progress bar on profile | `TierProgress.jsx` | Creator/ | — | ❌ Missing |
| Account standing indicator | `AccountStanding.jsx` | AntiAbuse/ | — | ❌ Missing |

### B. Earning Dashboard — Analytics Tab

| Feature | Web Component | API Endpoint | Mobile Status |
|---------|--------------|--------------|---------------|
| Earnings trend chart (7/30/90d) | `EarningsTrendChart.jsx` | `/api/revenue-analytics/trends` | ❌ Missing |
| Period comparison (vs previous) | `PeriodCompare.jsx` | `/api/revenue-analytics/trends` | ❌ Missing |
| Rank tracker (progression chart) | `RankTracker.jsx` | `/api/earning/my-ranking` | ❌ Missing |
| Content earnings table | `ContentEarningsTable.jsx` | `/api/revenue-analytics/content-earnings` | ❌ Missing |
| Score optimizer (AI recommendations) | `ScoreOptimizer.jsx` | `/api/revenue-analytics/score-optimizer` | ❌ Missing |
| Earning forecast | `EarningForecast.jsx` | `/api/revenue-analytics/forecast` | ❌ Missing |

### C. Earning Rulebook — Static vs Dynamic + Missing Sections

| Section | Web Status | Mobile Status | Issue |
|---------|-----------|---------------|-------|
| Overview | ✅ Dynamic | ⚠️ Static hardcoded | Revenue share % hardcoded as "50/50" |
| How It Works | ✅ Dynamic | ⚠️ Static hardcoded | Distribution formula hardcoded |
| Earning Activities | ✅ Dynamic (from score_weights) | ⚠️ Static hardcoded | Point values (+1.0, +2.0 etc) hardcoded |
| Bonuses & Multipliers | ✅ Dynamic (from bonus_multipliers) | ⚠️ Static hardcoded | Streak % and thresholds hardcoded |
| Distribution | ✅ Dynamic (from config) | ⚠️ Static hardcoded | "12 AM UTC" hardcoded |
| Eligibility | ✅ Dynamic (from eligible_user_criteria) | ⚠️ Static hardcoded | Criteria hardcoded |
| **Page Monetization** | ✅ Dynamic (from page_monetization) | ❌ Missing | **Not built + needs dynamic** |
| **Creator Tiers** | ✅ Dynamic (from tier_config) | ❌ Missing | **Not built + needs dynamic** |
| **Viral Bonuses** | ✅ Dynamic (from viral_config) | ❌ Missing | **Not built + needs dynamic** |
| Pro Tips | ✅ | ✅ (as Tips) | OK |
| FAQ | ✅ | ✅ | OK |

> **Phase 0 fixes ALL existing static sections AND adds the 3 missing sections — all dynamic.**

### D. Page Section

| Feature | Web Component | API Endpoint | Mobile Status |
|---------|--------------|--------------|---------------|
| Page monetization eligibility check | `PageEligibilityCard.jsx` | `/api/page-monetization/eligibility/:id` | ❌ Missing |
| Page monetization application | `PageApplicationForm.jsx` | `POST /api/page-monetization/apply/:id` | ❌ Missing |
| Page application status | `PageApplicationStatus.jsx` | `/api/page-monetization/status/:id` | ❌ Missing |
| Page earning overview | `PageEarningOverview.jsx` | `/api/earning/page-breakdown` | ❌ Missing |
| Page tier badge | `PageTierBadge.jsx` | `/api/page-monetization/tier/:id` | ❌ Missing |
| Page tier progress | `PageTierProgress.jsx` | `/api/page-monetization/tier-history/:id` | ❌ Missing |
| Page viral content history | `PageViralHistory.jsx` | `/api/page-monetization/viral/:id` | ❌ Missing |
| Page risk indicator | `PageRiskIndicator.jsx` | `/api/page-monetization/risk/:id` | ❌ Missing |
| "Monetize This Page" CTA | Single page view CTA | — | ❌ Missing |
| Page monetization status dots | `PageSelector.jsx` dots | — | ❌ Missing |
| Page breakdown in earning dash | `PageBreakdownCard.jsx` tier+viral | — | ⚠️ Partial (no tier/viral badges) |

### E. Creator Tier System

| Feature | Web Component | API Endpoint | Mobile Status |
|---------|--------------|--------------|---------------|
| Creator tier badge | `CreatorTierBadge.jsx` | `/api/creator/my-tier` | ❌ Missing |
| Tier progress (4 dimensions) | `TierProgress.jsx` | `/api/creator/my-tier` | ❌ Missing |
| Eligibility check | `EligibilityCard.jsx` | `/api/creator/eligibility` | ❌ Missing |
| Creator application form | `ApplicationForm.jsx` | `POST /api/creator/apply` | ❌ Missing |
| Application status tracking | `ApplicationStatus.jsx` | `/api/creator/application-status` | ❌ Missing |
| Priority score breakdown | `PriorityScoreBreakdown.jsx` | `/api/creator/priority-score` | ❌ Missing |
| Tier history timeline | `TierHistory.jsx` | `/api/creator/tier-history` | ❌ Missing |
| Creator dashboard page | `/creator/dashboard` route | — | ❌ Missing |

### F. Viral Content System

| Feature | Web Component | API Endpoint | Mobile Status |
|---------|--------------|--------------|---------------|
| Viral badge on posts | `ViralBadge.jsx` | `/api/viral/post/:id` | ❌ Missing |
| Rising badge (pre-viral) | `RisingBadge.jsx` | — | ❌ Missing |
| Viral score breakdown | `ViralScoreBreakdown.jsx` | `/api/viral/score/:id` | ❌ Missing |
| Viral bonus notification | `ViralBonusToast.jsx` | — | ❌ Missing |
| Trending card | `TrendingCard.jsx` | `/api/viral/trending` | ❌ Missing |
| Trending feed | `TrendingFeed.jsx` | `/api/viral/trending` | ❌ Missing |
| My viral posts | `MyViralPosts.jsx` | `/api/viral/my-posts` | ❌ Missing |

### G. Anti-Abuse System

| Feature | Web Component | Mobile Status |
|---------|--------------|---------------|
| Account standing page | `AccountStanding.jsx` | ❌ Missing |
| Warning banner (global) | `AccountWarningBanner.jsx` | ❌ Missing |
| Earnings frozen banner | `EarningFrozenBanner.jsx` | ❌ Missing |
| Rate limit warning | `RateLimitWarning.jsx` | ❌ Missing |
| Appeal form | `AppealForm.jsx` | ❌ Missing |
| Duplicate content warning | `DuplicateContentWarning.jsx` | ❌ Missing |

### H. Tipping System

| Feature | Web Component | API Endpoint | Mobile Status |
|---------|--------------|--------------|---------------|
| Tip button on profiles/posts | `TipButton.jsx` | `POST /api/tips/send` | ❌ Missing |
| Tip amount modal | `TipModal.jsx` | — | ❌ Missing |
| Tip received animation | `TipAnimation.jsx` | — | ❌ Missing |
| Tip received notification | `TipReceivedToast.jsx` | WebSocket | ❌ Missing |
| Top supporters list | `TopSupporters.jsx` | `/api/tips/supporters` | ❌ Missing |
| Tip goal progress bar | `TipGoalProgress.jsx` | `/api/tips/goals` | ❌ Missing |
| Tip goal form | `TipGoalForm.jsx` | `POST /api/tips/goals` | ❌ Missing |
| Tip history | `TipHistory.jsx` | `/api/tips/history` | ❌ Missing |
| Tip summary card | `TipSummaryCard.jsx` | `/api/tips/summary` | ❌ Missing |
| Supporter badge | `SupporterBadge.jsx` | — | ❌ Missing |
| Tip dashboard page | `/tips/dashboard` route | — | ❌ Missing |

---

## PHASE 0 — DYNAMIC CONFIG FOUNDATION (CRITICAL) <a id="phase-0"></a>

**Priority:** 🔴🔴 CRITICAL | **Effort:** Medium | **Backend Required:** None (API exists)  
**Status:** ✅ COMPLETED

### Overview

**This phase MUST be completed before all other phases.** Currently, the mobile app's `earning_guide_view.dart` has hardcoded values for score weights, bonus multipliers, eligibility rules, revenue share percentage, and distribution schedule. qp-web has already converted ALL of these to be **dynamically loaded from the admin-configured backend** via the `RevenueShareConfig` model.

When an admin changes configuration in qp-admin (e.g., changes reaction weight from 1.0 to 1.5, or streak bonus from 10% to 15%), the web UI reflects this instantly on next page load. The mobile app continues showing stale hardcoded values. This creates a **data inconsistency between platforms** and defeats the purpose of the admin config panel.

### Problem: Current Mobile Static Values in `earning_guide_view.dart`

```dart
// ❌ HARDCODED — These values will go stale when admin changes config
_scoreRow('Post Reaction Received', '+1.0'),
_scoreRow('Post Comment Received', '+2.0'),
_scoreRow('Post Share Received', '+3.0'),
_scoreRow('Reel View Received', '+0.5'),
_scoreRow('Story View Received', '+0.3'),
_scoreRow('Reaction Given', '+0.2'),
_scoreRow('Comment Given', '+0.5'),
_scoreRow('Share Given', '+0.3'),
_bonusTierRow('7-Day Streak', '+10%', Colors.blue),
_bonusTierRow('30-Day Streak', '+25%', Colors.orange),
_bonusTierRow('90-Day Streak', '+50%', Colors.red),
_infoText('Daily ad revenue is split 50/50 between the Creator Pool...');
_sectionCard('Distribution', '...daily at 12:00 AM UTC...');
```

### Solution: Dynamic Config Architecture

#### Step 1 — Create Global Config Model (`earning_config_model.dart`)

```dart
/// Mirrors the RevenueShareConfig from qp-api (admin-managed)
class EarningConfig {
  // Basic
  final double revenueSharePercentage;    // e.g., 50.0
  final String distributionTime;          // e.g., "00:00"
  final String distributionMode;          // 'score_based' | 'equal' | 'hybrid'
  final double maxUserSharePercentage;    // e.g., 10.0

  // Score Weights (all admin-configurable)
  final Map<String, double> scoreWeights;
  // Keys: post_reaction_received, post_comment_received, post_share_received,
  //        reel_view_received, story_view_received, reaction_given, comment_given,
  //        share_given, campaign_impression, campaign_click, campaign_reaction,
  //        campaign_comment, campaign_share, campaign_watch_10sec

  // Bonus Multipliers
  final Map<String, double> bonusMultipliers;
  // Keys: streak_7_days, streak_30_days, streak_90_days, verified_creator

  // Streak Thresholds
  final int streakTier1Days;              // e.g., 7
  final int streakTier2Days;              // e.g., 30
  final int streakTier3Days;              // e.g., 90

  // User Eligibility
  final double minEngagementScore;
  final int minAccountAgeDays;
  final bool monetizationEnabled;

  // Page Monetization Config
  final PageMonetizationConfig? pageMonetization;

  // Tier Config
  final TierConfig? tierConfig;

  // Viral Config
  final ViralConfig? viralConfig;

  // Page Anti-Abuse Config
  final AntiAbuseConfig? antiAbuse;

  EarningConfig.fromJson(Map<String, dynamic> json) { ... }
}

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

  PageMonetizationConfig.fromJson(Map<String, dynamic> json) { ... }
}

class TierConfig {
  final bool enabled;
  final int evaluationPeriodDays;
  final int demotionGracePeriodDays;
  final double maxTotalMultiplier;
  final List<TierDefinition> userTiers;
  final List<TierDefinition> pageTiers;
  final Map<String, double> userScoreWeights;
  final Map<String, double> pageScoreWeights;

  TierConfig.fromJson(Map<String, dynamic> json) { ... }
}

class TierDefinition {
  final String key;       // 'basic', 'growth', 'premium'
  final String label;     // Admin-defined display name
  final double multiplier;
  final int minScore;
  final int maxScore;
  final String color;

  TierDefinition.fromJson(Map<String, dynamic> json) { ... }
}

class ViralConfig {
  final bool enabled;
  final int evaluationWindowHours;
  final int detectionIntervalHours;
  final bool applyToUsers;
  final bool applyToPages;
  final List<ViralThreshold> thresholds;

  ViralConfig.fromJson(Map<String, dynamic> json) { ... }
}

class ViralThreshold {
  final String key;       // 'rising', 'viral', 'mega_viral'
  final String label;     // Admin-defined display name
  final double multiplier;
  final int minScore;
  final int maxScore;
  final int maxDurationHours;

  ViralThreshold.fromJson(Map<String, dynamic> json) { ... }
}

class AntiAbuseConfig {
  final bool fakeDetectionEnabled;
  final int fakeScoreThreshold;
  final int autoFreezeThreshold;
  final String scanFrequency;

  AntiAbuseConfig.fromJson(Map<String, dynamic> json) { ... }
}
```

#### Step 2 — Create Config Service (`earning_config_service.dart`)

```dart
class EarningConfigService extends GetxService {
  final Rx<EarningConfig?> config = Rx<EarningConfig?>(null);
  final RxBool isLoaded = false.obs;

  // Cache duration: 1 hour (refresh in background)
  DateTime? _lastFetched;
  static const _cacheDuration = Duration(hours: 1);

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();   // Load cached config instantly
    fetchConfig();      // Then fetch fresh from API
  }

  Future<void> fetchConfig() async {
    try {
      final response = await DioClient().get('/api/earning/score-weights');
      if (response.data['status'] == 200 || response.data['success'] == true) {
        config.value = EarningConfig.fromJson(response.data['data']);
        isLoaded.value = true;
        _lastFetched = DateTime.now();
        _saveToCache(response.data['data']);  // Persist for offline use
      }
    } catch (e) {
      // Fallback: use cached data if available
      if (config.value == null) _loadFromCache();
    }
  }

  // Cache in GetStorage/Hive for offline access
  void _saveToCache(Map<String, dynamic> data) { ... }
  void _loadFromCache() { ... }

  // Convenience getters used by ALL widgets across the app
  double get revenueSharePercent => config.value?.revenueSharePercentage ?? 50.0;
  Map<String, double> get scoreWeights => config.value?.scoreWeights ?? {};
  Map<String, double> get bonusMultipliers => config.value?.bonusMultipliers ?? {};
  bool get tierEnabled => config.value?.tierConfig?.enabled ?? false;
  bool get viralEnabled => config.value?.viralConfig?.enabled ?? false;
  bool get pageMonetizationEnabled => config.value?.pageMonetization?.enabled ?? false;
  List<TierDefinition> get userTiers => config.value?.tierConfig?.userTiers ?? [];
  List<TierDefinition> get pageTiers => config.value?.tierConfig?.pageTiers ?? [];
  List<ViralThreshold> get viralThresholds => config.value?.viralConfig?.thresholds ?? [];
}
```

#### Step 3 — Register as Global Service

```dart
// In main.dart or initial_bindings.dart
Get.put(EarningConfigService(), permanent: true);
```

This ensures config is available app-wide, fetched once, cached, and all widgets read from it.

#### Step 4 — Convert `earning_guide_view.dart` to Dynamic

**BEFORE (static):**
```dart
_scoreRow('Post Reaction Received', '+1.0'),  // ❌ Hardcoded
```

**AFTER (dynamic):**
```dart
final configService = Get.find<EarningConfigService>();
// ...
Obx(() {
  final sw = configService.scoreWeights;
  return Column(children: [
    _scoreRow('Post Reaction Received', '+${sw['post_reaction_received'] ?? 1.0}'),
    _scoreRow('Post Comment Received', '+${sw['post_comment_received'] ?? 2.0}'),
    _scoreRow('Post Share Received', '+${sw['post_share_received'] ?? 3.0}'),
    // ... all values from API, defaults only as fallback
  ]);
})
```

**BEFORE (static bonuses):**
```dart
_bonusTierRow('7-Day Streak', '+10%', Colors.blue),  // ❌ Hardcoded
```

**AFTER (dynamic):**
```dart
Obx(() {
  final bm = configService.bonusMultipliers;
  final thresholds = configService.config.value;
  return Column(children: [
    _bonusTierRow(
      '${thresholds?.streakTier1Days ?? 7}-Day Streak',
      '+${((bm['streak_7_days'] ?? 0.1) * 100).toInt()}%',
      Colors.blue,
    ),
    _bonusTierRow(
      '${thresholds?.streakTier2Days ?? 30}-Day Streak',
      '+${((bm['streak_30_days'] ?? 0.25) * 100).toInt()}%',
      Colors.orange,
    ),
    _bonusTierRow(
      '${thresholds?.streakTier3Days ?? 90}-Day Streak',
      '+${((bm['streak_90_days'] ?? 0.5) * 100).toInt()}%',
      Colors.red,
    ),
  ]);
})
```

**BEFORE (static revenue share):**
```dart
_infoText('Daily ad revenue is split 50/50...');  // ❌ Hardcoded
```

**AFTER (dynamic):**
```dart
Obx(() {
  final pct = configService.revenueSharePercent;
  return _infoText('Daily ad revenue is split ${pct.toInt()}/${(100 - pct).toInt()} between the Creator Pool...');
})
```

#### Step 5 — Add 3 New Dynamic Sections to Earning Guide

Using the same config service, add the 3 missing web sections:

**Section 7: Page Monetization** (only shown if `configService.pageMonetizationEnabled`)
```dart
Obx(() {
  if (!configService.pageMonetizationEnabled) return SizedBox.shrink();
  final pm = configService.config.value!.pageMonetization!;
  return _sectionCard('Page Monetization', children: [
    _infoText('Pages can earn their own revenue share with enhanced multipliers.'),
    _ruleRow('Minimum Page Age', '${pm.minPageAgeDays} days'),
    _ruleRow('Minimum Followers', '${pm.minFollowers}'),
    _ruleRow('Minimum Monthly Views', '${pm.minMonthlyViews}'),
    _ruleRow('Min Content Count', '${pm.minContentCount} posts'),
    _ruleRow('Min Engagement Rate', '${pm.minEngagementRate}%'),
    _ruleRow('Max Pages Per User', '${pm.maxPagesPerUser}'),
    // Show page tiers dynamically
    ...configService.pageTiers.map((tier) =>
      _tierRow(tier.label, '${tier.multiplier}x', tier.minScore, tier.maxScore)),
  ]);
})
```

**Section 8: Creator Tiers** (only shown if `configService.tierEnabled`)
```dart
Obx(() {
  if (!configService.tierEnabled) return SizedBox.shrink();
  final tc = configService.config.value!.tierConfig!;
  return _sectionCard('Creator Tiers', children: [
    _infoText('Earn more as you grow! Higher tiers = bigger multipliers.'),
    ...configService.userTiers.map((tier) =>
      _tierRow(tier.label, '${tier.multiplier}x', tier.minScore, tier.maxScore)),
    _subHeader('Scoring Dimensions:'),
    ...tc.userScoreWeights.entries.map((e) =>
      _dimensionRow(e.key, '${(e.value * 100).toInt()}%')),
    _ruleRow('Evaluation Period', '${tc.evaluationPeriodDays} days'),
    _ruleRow('Demotion Grace', '${tc.demotionGracePeriodDays} days'),
  ]);
})
```

**Section 9: Viral Bonuses** (only shown if `configService.viralEnabled`)
```dart
Obx(() {
  if (!configService.viralEnabled) return SizedBox.shrink();
  final vc = configService.config.value!.viralConfig!;
  return _sectionCard('Viral Bonuses', children: [
    _infoText('Content that goes viral earns bonus multipliers automatically!'),
    ...configService.viralThresholds.map((t) =>
      _viralTierRow(t.label, '${t.multiplier}x', '${t.maxDurationHours}h')),
    _ruleRow('Detection Interval', 'Every ${vc.detectionIntervalHours} hours'),
    _ruleRow('Applies to Users', vc.applyToUsers ? 'Yes' : 'No'),
    _ruleRow('Applies to Pages', vc.applyToPages ? 'Yes' : 'No'),
  ]);
})
```

### Files to Create

```
lib/app/modules/earnDashboard/
├── models/
│   └── earning_config_model.dart            ← NEW: Full config model (mirrors RevenueShareConfig)
└── services/
    └── earning_config_service.dart           ← NEW: Global GetxService with caching
```

### Files to Modify

| File | Changes |
|------|---------|
| `main.dart` or `initial_bindings.dart` | Register `EarningConfigService` as permanent global service |
| `earning_guide_view.dart` | **MAJOR REWRITE**: Replace ALL hardcoded values with `Obx()` reading from `EarningConfigService`; add 3 new dynamic sections |
| `earn_dashboard_controller.dart` | Use `EarningConfigService` instead of local config parsing |
| `score_weights_card.dart` | Already partially dynamic, ensure it reads from global service |
| `today_estimate_card.dart` | Read bonus multiplier labels from config service |
| `platform_stats_card.dart` | Read revenue share % from config service |
| `score_breakdown_card.dart` | Read activity labels from config service |

### Admin Config API Response Structure

The single `/api/earning/score-weights` endpoint returns ALL config in one call:

```json
{
  "status": 200,
  "data": {
    "revenue_share_percentage": 50,
    "distribution_time": "00:00",
    "distribution_mode": "score_based",
    "max_user_share_percentage": 10,
    "score_weights": {
      "post_reaction_received": 1.0,
      "post_comment_received": 2.0,
      "post_share_received": 3.0,
      "reel_view_received": 0.5,
      "story_view_received": 0.3,
      "reaction_given": 0.2,
      "comment_given": 0.5,
      "share_given": 0.3,
      "campaign_impression": 0.1,
      "campaign_click": 0.5,
      "campaign_reaction": 0.3,
      "campaign_comment": 0.5,
      "campaign_share": 0.5,
      "campaign_watch_10sec": 0.8
    },
    "bonus_multipliers": {
      "streak_7_days": 0.10,
      "streak_30_days": 0.25,
      "streak_90_days": 0.50,
      "verified_creator": 0.15
    },
    "streak_thresholds": { "tier_1_days": 7, "tier_2_days": 30, "tier_3_days": 90 },
    "eligible_user_criteria": {
      "min_engagement_score": 1,
      "min_account_age_days": 7,
      "monetization_enabled": true
    },
    "page_monetization": {
      "enabled": true,
      "min_page_age_days": 30,
      "min_followers": 1000,
      "min_monthly_views": 10000,
      "min_content_count": 20,
      "min_engagement_rate": 2.0,
      "require_owner_monetized": true,
      "max_pages_per_user": 5
    },
    "tier_config": {
      "enabled": true,
      "evaluation_period_days": 30,
      "demotion_grace_period_days": 14,
      "max_total_multiplier": 3.0,
      "user_tiers": [
        { "key": "basic", "label": "Basic", "multiplier": 1.0, "min_score": 0, "max_score": 39 },
        { "key": "growth", "label": "Growth", "multiplier": 1.5, "min_score": 40, "max_score": 74 },
        { "key": "premium", "label": "Premium", "multiplier": 2.0, "min_score": 75, "max_score": 100 }
      ],
      "page_tiers": [ /* same structure */ ],
      "user_score_weights": { "watch_time": 0.35, "engagement": 0.30, "consistency": 0.20, "content_quality": 0.15 },
      "page_score_weights": { "watch_time": 0.35, "engagement": 0.30, "consistency": 0.20, "content_quality": 0.15 }
    },
    "viral_config": {
      "enabled": true,
      "evaluation_window_hours": 24,
      "detection_interval_hours": 2,
      "apply_to_users": true,
      "apply_to_pages": true,
      "thresholds": [
        { "key": "rising", "label": "Rising", "multiplier": 1.5, "min_score": 50, "max_score": 74, "max_duration_hours": 24 },
        { "key": "viral", "label": "Viral", "multiplier": 2.0, "min_score": 75, "max_score": 89, "max_duration_hours": 48 },
        { "key": "mega_viral", "label": "Mega Viral", "multiplier": 3.0, "min_score": 90, "max_score": 100, "max_duration_hours": 72 }
      ]
    },
    "page_anti_abuse": {
      "fake_detection_enabled": true,
      "fake_score_threshold": 60,
      "auto_freeze_threshold": 80,
      "scan_frequency": "daily"
    }
  }
}
```

### Dynamic Config Rules (APPLIES TO ALL SUBSEQUENT PHASES)

> **🔴 MANDATORY RULE FOR ALL PHASES:**
> 
> 1. **NEVER hardcode** any value that comes from admin config (score weights, multipliers, thresholds, tier names, eligibility criteria, etc.)
> 2. **ALWAYS** read from `EarningConfigService` — use `Obx()` for reactive UI updates
> 3. **ALWAYS** provide sensible defaults as fallback (for offline / first launch before API responds)
> 4. **Show/hide entire sections** based on feature flags (`tierConfig.enabled`, `viralConfig.enabled`, `pageMonetization.enabled`)
> 5. **Cache config** in GetStorage/Hive for offline access — refresh on app foreground
> 6. **Admin can change ANY value at any time** — UI must reflect without app update
> 7. **Labels, names, multipliers, thresholds** — ALL must be from API, not from code

### Verification Checklist (Phase 0 Completion)

- [x] `EarningConfigService` created and registered globally
- [x] Config fetched from `/api/earning/score-weights` on app start
- [x] Config cached in local storage (offline support)
- [x] `earning_guide_view.dart` — ALL hardcoded values replaced with dynamic config
- [x] Revenue share % reads from config (not hardcoded "50/50")
- [x] Score weights read from config (not hardcoded "+1.0", "+2.0")
- [x] Bonus multipliers read from config (not hardcoded "10%", "25%", "50%")
- [x] Streak thresholds read from config (not hardcoded 7/30/90)
- [x] Eligibility criteria read from config
- [x] Distribution time reads from config (not hardcoded "12 AM UTC")
- [x] 3 new sections added (Page Monetization, Creator Tiers, Viral Bonuses)
- [x] New sections show/hide based on `enabled` flags
- [x] Tier names/multipliers/thresholds all from `user_tiers[]` / `page_tiers[]`
- [x] Viral thresholds/labels/multipliers all from `thresholds[]`
- [x] Existing dashboard widgets updated to use global config service
- [x] Fallback defaults work when API unavailable (offline mode)

---

## PHASE 1 — EARNING ANALYTICS DASHBOARD <a id="phase-1"></a>

**Priority:** 🔴 HIGH | **Effort:** Medium | **Backend Required:** None (APIs exist)  
**Depends on:** Phase 0 (EarningConfigService must exist)  
**Status:** ✅ COMPLETED

### Overview
Add a third "Analytics" tab to the existing earning dashboard, providing visual charts and actionable insights.

### ⚠️ Dynamic Config Requirement
- Period options and chart labels may come from config in future — use config service pattern
- Score optimizer recommendations should reference actual score weights from `EarningConfigService`
- Forecast calculations should use current revenue share % from config, not hardcoded values

### Files to Create

```
lib/app/modules/earnDashboard/
├── views/
│   └── earning_analytics_view.dart          ← NEW: Analytics tab view
├── widgets/
│   ├── analytics/
│   │   ├── earnings_trend_chart.dart        ← NEW: Area/line chart (7/30/90d)
│   │   ├── period_compare_card.dart         ← NEW: Current vs previous period
│   │   ├── rank_tracker_card.dart           ← NEW: Rank progression chart
│   │   ├── content_earnings_card.dart       ← NEW: Per-content earnings bar chart
│   │   ├── score_optimizer_card.dart        ← NEW: AI recommendations
│   │   └── earning_forecast_card.dart       ← NEW: Projected earnings
├── model/
│   └── analytics_models.dart                ← NEW: Analytics data models
└── services/
    └── earning_api_service.dart             ← MODIFY: Add analytics endpoints
```

### Files to Modify
- `earn_dashboard_view.dart` — Add 3rd "Analytics" tab to TabBar/TabBarView
- `earn_dashboard_controller.dart` — Add analytics state, period selector, fetch methods
- `earning_api_service.dart` — Add 4 new API methods

### API Endpoints to Integrate

| Endpoint | Method | Response Fields |
|----------|--------|-----------------|
| `GET /api/revenue-analytics/trends?period=7d\|30d\|90d` | GET | `dailyData[]`, `totalEarned`, `avgDaily`, `bestDay`, `worstDay`, `trend` |
| `GET /api/revenue-analytics/content-earnings?period=7d` | GET | `contentList[]` (postId, type, title, views, engagement, earned) |
| `GET /api/revenue-analytics/score-optimizer` | GET | `weekSummary`, `streakStatus`, `recommendations[]`, `activityROI[]` |
| `GET /api/revenue-analytics/forecast` | GET | `projectedEarnings`, `confidence`, `basedOn`, `trendDirection` |

### Data Models to Create (`analytics_models.dart`)

```dart
class EarningsTrendData {
  final List<DailyTrendPoint> dailyData;
  final double totalEarned;
  final double avgDaily;
  final DayHighlight bestDay;
  final DayHighlight worstDay;
  final String trend; // 'up' | 'down' | 'stable'
}

class DailyTrendPoint {
  final String date;
  final double earned;
  final double score;
  final int rank;
}

class PeriodCompareData {
  final double currentTotal;
  final double previousTotal;
  final double changePercent;
  final String direction; // 'up' | 'down' | 'stable'
}

class ContentEarningEntry {
  final String postId;
  final String type; // 'post' | 'reel' | 'story'
  final String title;
  final int views;
  final int engagement;
  final double earned;
}

class ScoreOptimizerData {
  final WeekSummary weekSummary;
  final StreakStatus streakStatus;
  final List<Recommendation> recommendations;
  final List<ActivityROI> activityROI;
}

class Recommendation {
  final String priority; // 'high' | 'medium' | 'info'
  final String title;
  final String description;
  final String actionText;
}

class EarningForecastData {
  final double projectedWeekly;
  final double projectedMonthly;
  final double confidence;
  final String trendDirection;
}
```

### Widget Specifications

#### 1. `earnings_trend_chart.dart`
- **Chart:** fl_chart `LineChart` with area fill
- **Period selector:** SegmentedButton (7d / 30d / 90d)
- **Data points:** Daily earned amount, tooltips on tap
- **Summary row:** Total earned | Avg daily | Best day
- **Colors:** Green for uptrend, red for downtrend

#### 2. `period_compare_card.dart`
- **Layout:** Two columns (Current Period vs Previous Period)
- **Metrics:** Total earned, avg daily, total score
- **Change indicator:** ↑ green or ↓ red with % change
- **Animation:** Counter animation on load

#### 3. `rank_tracker_card.dart`
- **Chart:** fl_chart `LineChart` showing rank over time
- **Stats:** Current rank, best rank, rank movement (▲/▼)
- **Period:** Matches global period selector

#### 4. `content_earnings_card.dart`
- **Layout:** Horizontal bar chart / sorted list
- **Per item:** Content type icon, title (truncated), views, engagement, $ earned
- **Sortable:** By earnings, views, engagement
- **Max items:** 20 with "Show More" scroll

#### 5. `score_optimizer_card.dart`
- **7-day summary:** Activities done vs recommended
- **Streak status:** Current streak days, next milestone
- **Recommendations:** Priority-colored cards (high=red, medium=yellow, info=blue)
- **Activity ROI table:** Activity type | Count × Weight | % of total | Insight

#### 6. `earning_forecast_card.dart`
- **Projected values:** 7-day and 30-day forecast
- **Confidence indicator:** Progress bar (%)
- **Trend direction:** Arrow + label
- **Disclaimer:** "Projections based on current activity trends"

### Chart Library
- **Recommended:** `fl_chart` (already used in marketplace seller insights, already a dependency)
- **Alternative:** `syncfusion_flutter_charts` (if more complex charts needed)

---

## PHASE 2 — PAGE MONETIZATION SYSTEM <a id="phase-2"></a>

**Priority:** 🔴 HIGH | **Effort:** Large | **Backend Required:** None (APIs exist)  
**Depends on:** Phase 0 (config service for eligibility thresholds, tier definitions, feature flags)  
**Status:** ✅ COMPLETED

### Overview
Complete page monetization flow — check eligibility, apply, track status, view tier/viral/risk data. Integrates into page profile and earning dashboard.

### ⚠️ Dynamic Config Requirement
- **Eligibility thresholds** (min followers, views, age, engagement) — ALL from `EarningConfigService.pageMonetization`
- **Tier names, multipliers, score ranges** — from `EarningConfigService.pageTiers`
- **Viral thresholds** (rising/viral/mega labels, multipliers, durations) — from `EarningConfigService.viralThresholds`
- **Anti-abuse thresholds** (risk score levels, freeze threshold) — from `EarningConfigService.antiAbuse`
- **Feature visibility** — entire page monetization section hidden if `pageMonetization.enabled == false`
- **Do NOT hardcode** "1000 followers" or "10000 views" — read from API config, show admin-set values

### Files to Create

```
lib/app/modules/pageMonetization/
├── bindings/
│   └── page_monetization_binding.dart       ← NEW: GetX binding
├── controllers/
│   └── page_monetization_controller.dart    ← NEW: State management
├── views/
│   ├── page_monetization_view.dart          ← NEW: Main dashboard
│   └── page_monetization_detail_view.dart   ← NEW: Single page detail
├── widgets/
│   ├── page_eligibility_card.dart           ← NEW: Eligibility criteria
│   ├── page_application_form.dart           ← NEW: Apply for monetization
│   ├── page_application_status.dart         ← NEW: Track application
│   ├── page_earning_overview.dart           ← NEW: Page earning summary
│   ├── page_tier_badge.dart                 ← NEW: Tier badge (reusable)
│   ├── page_tier_progress.dart              ← NEW: Tier progression
│   ├── page_viral_history.dart              ← NEW: Viral content list
│   └── page_risk_indicator.dart             ← NEW: Risk score display
├── models/
│   └── page_monetization_models.dart        ← NEW: All data models
└── services/
    └── page_monetization_api_service.dart   ← NEW: API service
```

### Files to Modify
- `app_routes.dart` — Add `/page-monetization` route
- `app_pages.dart` — Register page with binding
- `page_profile_view.dart` — Add "Monetize" button & tier badge
- `page_profile_controller.dart` — Add monetization status check
- `earn_dashboard_view.dart` — Enhance PageBreakdownCard with tier/viral indicators

### API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `GET /api/page-monetization/eligibility/:pageId` | GET | Check page eligibility criteria |
| `POST /api/page-monetization/apply/:pageId` | POST | Submit monetization application |
| `GET /api/page-monetization/status/:pageId` | GET | Get application/monetization status |
| `GET /api/page-monetization/my-pages` | GET | List user's pages with monetization status |
| `GET /api/page-monetization/tier/:pageId` | GET | Get tier info (name, multiplier, dimensions) |
| `GET /api/page-monetization/tier-history/:pageId` | GET | Tier progression timeline |
| `GET /api/page-monetization/viral/:pageId` | GET | List viral content for page |
| `GET /api/page-monetization/risk/:pageId` | GET | Risk profile & detected signals |

### Data Models (`page_monetization_models.dart`)

```dart
class PageEligibility {
  final bool isEligible;
  final List<EligibilityCriteria> criteria;
  final String message;
}

class EligibilityCriteria {
  final String name;       // 'followers', 'monthly_views', 'account_age', etc.
  final dynamic current;
  final dynamic required;
  final bool met;
}

class PageMonetizationStatus {
  final String status;     // 'not_applied' | 'pending' | 'under_review' | 'approved' | 'rejected' | 'suspended'
  final String? reviewNote;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
}

class PageTierInfo {
  final String tierName;   // 'Basic' | 'Growth' | 'Premium'
  final double multiplier; // 1.0x, 1.5x, 2.0x
  final int priorityScore;
  final Map<String, DimensionScore> dimensions; // watchTime, engagement, consistency, contentQuality
  final int nextTierThreshold;
}

class DimensionScore {
  final String name;
  final double score;
  final double weight;     // watchTime=35%, engagement=30%, consistency=20%, quality=15%
  final double weightedScore;
}

class PageViralContent {
  final String postId;
  final String status;     // 'rising' | 'viral' | 'mega_viral' | 'expired'
  final int viralScore;
  final double bonusMultiplier;
  final double bonusEarnings;
  final int views;
  final int shares;
  final DateTime detectedAt;
}

class PageRiskProfile {
  final int riskScore;     // 0-100
  final String riskLevel;  // 'low' | 'medium' | 'high' | 'critical'
  final List<RiskSignal> signals;
  final bool earningsFrozen;
  final DateTime? lastScanAt;
}

class RiskSignal {
  final String type;       // 'fake_followers', 'bot_engagement', 'content_violation'
  final String description;
  final String severity;   // 'low' | 'medium' | 'high'
}

class PageMonetizationSummary {
  final String pageId;
  final String pageName;
  final String? profilePic;
  final String monetizationStatus;  // green dot / yellow dot / red dot / none
  final String? tierName;
  final double? multiplier;
  final int followers;
}
```

### Widget Specifications

#### 1. `page_monetization_view.dart` — Main Dashboard
- **Page selector dropdown** at top (user's pages) — with status dots (green=active, yellow=pending, red=suspended, gray=not applied)
- **Sections based on status:**
  - Not applied → Show `PageEligibilityCard` + `PageApplicationForm`
  - Pending → Show `PageApplicationStatus`
  - Approved → Show `PageEarningOverview` + `PageTierProgress` + `PageViralHistory`
  - Suspended → Show warning banner + `PageRiskIndicator`

#### 2. `page_eligibility_card.dart`
- **Criteria list** with checkmarks (✅) or X marks (❌):
  - Page age ≥ 30 days
  - Followers ≥ 1,000
  - Monthly views ≥ 10,000
  - Total posts ≥ 20
  - Engagement rate ≥ 2%
- **Progress bar** for unmet criteria (current/required)
- **Call-to-action:** "Apply Now" when all met, "Keep Going" when not

#### 3. `page_application_form.dart`
- **Summary of eligibility** (compact)
- **Confirmation checkbox:** "I confirm my content complies with community guidelines"
- **Submit button** (enabled only when eligible + confirmed)
- **Terms link**

#### 4. `page_application_status.dart`
- **Status timeline:** Submitted → Under Review → Decision
- **Current status badge** with color coding
- **Review note** (if rejected, shows reason)
- **Dates** (submitted, reviewed)

#### 5. `page_earning_overview.dart`
- **Today's score** for this specific page
- **% of total earnings** from this page
- **Tier badge** + multiplier display
- **Viral posts count** + bonus indicator
- **Status badge:** Active / Frozen / Inactive

#### 6. `page_tier_badge.dart` (Reusable Widget)
- **Small tag:** "Basic 1.0x" / "Growth 1.5x" / "Premium 2.0x"
- **Colors:** Gray (Basic), Blue (Growth), Amber/Gold (Premium)
- **Sizes:** small (for lists) / medium (for profiles) / large (for dashboard)
- **Used in:** Page profile header, page selector list, earning breakdown, page monetization dashboard

#### 7. `page_tier_progress.dart`
- **4-dimension radar/bar chart:**
  - Watch Time (35%)
  - Engagement (30%)
  - Consistency (20%)
  - Content Quality (15%)
- **Progress bar** to next tier
- **Tier history timeline** (promotions/demotions with dates)

#### 8. `page_viral_history.dart`
- **List of viral content:**
  - Status badge (Rising 🟡 / Viral 🔴 / Mega Viral 🟣 / Expired ⚫)
  - Viral score (0-100)
  - Bonus multiplier (1.5x / 2.0x / 3.0x)
  - Bonus earnings amount
  - View/share metrics
  - Detected date

#### 9. `page_risk_indicator.dart`
- **Risk score gauge** (0-100) with color gradient
- **Risk level label** with icon
- **Detected signals list** (severity-colored)
- **Frozen status** warning if applicable
- **Last scan date**

### Page Profile Integration
- Add `PageTierBadge` next to page name in `page_profile_view.dart`
- Add "Monetize This Page" CTA button for page owners (visible if not yet monetized)
- Add monetization status indicator (small dot) in page list views

---

## PHASE 3 — CREATOR TIER SYSTEM <a id="phase-3"></a>

**Priority:** 🔴 HIGH | **Effort:** Medium | **Backend Required:** None (APIs exist)  
**Depends on:** Phase 0 (config service for tier definitions, scoring dimensions)  
**Status:** ✅ COMPLETED

### Overview
User-level tier system showing creator progression with badges and priority scoring. Integrates into user profile and earning dashboard.

### ⚠️ Dynamic Config Requirement
- **Tier names, multipliers, score ranges** — from `EarningConfigService.userTiers` (NOT hardcoded "Starter/Rising Star/Pro/Elite")
- **Scoring dimension weights** — from `EarningConfigService.config.tierConfig.userScoreWeights` (NOT hardcoded 35%/30%/20%/15%)
- **Evaluation period, demotion grace** — from config
- **Tier badge colors** — can be defined in tier definition or mapped from `tier.key`
- **Feature visibility** — entire creator tier section hidden if `tierConfig.enabled == false`

### Files to Create

```
lib/app/modules/creatorTier/
├── bindings/
│   └── creator_tier_binding.dart            ← NEW
├── controllers/
│   └── creator_tier_controller.dart         ← NEW
├── views/
│   └── creator_dashboard_view.dart          ← NEW: Creator tier dashboard
├── widgets/
│   ├── creator_tier_badge.dart              ← NEW: Reusable badge
│   ├── tier_progress_card.dart              ← NEW: 4-dimension progress
│   ├── eligibility_card.dart                ← NEW: Creator eligibility
│   ├── application_form.dart                ← NEW: Apply for creator tier
│   ├── application_status.dart              ← NEW: Track application
│   ├── priority_score_breakdown.dart        ← NEW: Score details
│   └── tier_history_card.dart               ← NEW: Promotion timeline
├── models/
│   └── creator_tier_models.dart             ← NEW
└── services/
    └── creator_tier_api_service.dart        ← NEW
```

### Files to Modify
- `app_routes.dart` — Add `/creator-dashboard` route
- `app_pages.dart` — Register with binding
- `profile_view.dart` — Add `CreatorTierBadge` next to username
- `earn_dashboard_controller.dart` — Add creator tier status fetching
- `today_estimate_card.dart` — Show tier multiplier badge

### API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `GET /api/creator/my-tier` | GET | Current tier, multiplier, 4-dimension scores |
| `GET /api/creator/eligibility` | GET | Eligibility criteria check |
| `POST /api/creator/apply` | POST | Apply for creator program |
| `GET /api/creator/application-status` | GET | Application tracking |
| `GET /api/creator/priority-score` | GET | Detailed score breakdown |
| `GET /api/creator/tier-history` | GET | Tier changes timeline |

### Data Models (`creator_tier_models.dart`)

```dart
class CreatorTierInfo {
  final String tierName;       // 'Starter' | 'Rising Star' | 'Pro Creator' | 'Elite'
  final double multiplier;
  final int priorityScore;
  final Map<String, DimensionScore> dimensions;
  final String nextTier;
  final int nextTierThreshold;
  final int currentProgress;
}

class CreatorEligibility {
  final bool isEligible;
  final List<EligibilityCriteria> criteria;
  // Criteria: account_age >= 30d, followers >= 100, posts >= 10, engagement >= 1%
}

class CreatorApplication {
  final String status;     // 'not_applied' | 'pending' | 'approved' | 'rejected'
  final DateTime? appliedAt;
  final DateTime? reviewedAt;
  final String? reason;
}

class PriorityScoreBreakdown {
  final int totalScore;
  final Map<String, DimensionDetail> dimensions;
  // 4 dimensions: watchTime(35%), engagement(30%), consistency(20%), contentQuality(15%)
}

class TierHistoryEntry {
  final String fromTier;
  final String toTier;
  final String action;     // 'promotion' | 'demotion'
  final DateTime date;
  final String reason;
}
```

### Widget Specifications

#### 1. `creator_tier_badge.dart` (Reusable)
- **Tiers:** Loaded dynamically from `EarningConfigService.userTiers` — admin defines tier keys, labels, multipliers, score ranges
- **Color mapping:** Map from `tier.key` → color (e.g., 'basic' → gray, 'growth' → blue, 'premium' → gold)
- **Sizes:** small (16px) / medium (24px) / large (36px)
- **Display:** Icon + tier name (from API) + multiplier (from API)
- **Used in:** User profile header, earning dashboard, post author labels
- **⚠️ Do NOT hardcode** tier names like "Starter/Rising Star/Pro/Elite" — use `tier.label` from config

#### 2. `tier_progress_card.dart`
- **Radar chart or 4 horizontal progress bars** — dimension names and weights from `EarningConfigService.config.tierConfig.userScoreWeights`
- **Do NOT hardcode** "Watch Time (35%)" — read dimension names + weights from API
- **Overall progress** to next tier (threshold from `userTiers[]`)
- **Labels:** Current tier → Next tier with score needed (both from API)

#### 3. `eligibility_card.dart`
- Same pattern as page eligibility — criteria checklist
- Criteria: Account age, followers, posts, engagement rate
- CTA: "Apply for Creator Program"

#### 4. `priority_score_breakdown.dart`
- **Total score** with trend indicator
- **Per-dimension detail:**
  - Dimension name + weight percentage
  - Raw score → weighted contribution
  - Improvement tips per dimension

---

## PHASE 4 — VIRAL CONTENT SYSTEM <a id="phase-4"></a>

**Priority:** 🟡 MEDIUM | **Effort:** Medium | **Backend Required:** None (APIs exist)  
**Depends on:** Phase 0 (config service for viral thresholds, feature flags)  
**Status:** ✅ COMPLETED

### Overview
Visual indicators for viral content + trending feed + personal viral post tracking.

### ⚠️ Dynamic Config Requirement
- **Viral tier labels** (Rising/Viral/Mega Viral) — from `EarningConfigService.viralThresholds[].label`
- **Multipliers** (1.5x/2.0x/3.0x) — from `viralThresholds[].multiplier`
- **Duration** (24h/48h/72h) — from `viralThresholds[].maxDurationHours`
- **Detection interval** — from `viralConfig.detectionIntervalHours`
- **Feature visibility** — viral badges/feed hidden if `viralConfig.enabled == false`
- **Do NOT hardcode** "Rising = 1.5x" — admin may change multipliers at any time

### Files to Create

```
lib/app/modules/viralContent/
├── bindings/
│   └── viral_content_binding.dart           ← NEW
├── controllers/
│   └── viral_content_controller.dart        ← NEW
├── views/
│   ├── trending_feed_view.dart              ← NEW: Trending posts feed
│   └── my_viral_posts_view.dart             ← NEW: User's viral posts
├── widgets/
│   ├── viral_badge.dart                     ← NEW: Post overlay badge
│   ├── rising_badge.dart                    ← NEW: Pre-viral indicator
│   ├── viral_score_breakdown.dart           ← NEW: Score detail sheet
│   ├── viral_bonus_toast.dart               ← NEW: Bonus notification
│   └── trending_card.dart                   ← NEW: Trending post card
├── models/
│   └── viral_content_models.dart            ← NEW
└── services/
    └── viral_api_service.dart               ← NEW
```

### Files to Modify
- `app_routes.dart` — Add `/trending` route
- Post card widgets — Add viral/rising badge overlay
- Newsfeed — Inject trending section

### API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `GET /api/viral/trending` | GET | List trending posts |
| `GET /api/viral/my-posts` | GET | User's viral content list |
| `GET /api/viral/post/:id` | GET | Viral status for specific post |
| `GET /api/viral/score/:id` | GET | Detailed viral score breakdown |

### Viral Classification Tiers (Admin-Configured)

These values are examples — actual values come from `EarningConfigService.viralThresholds[]`. **Do NOT hardcode.**

| Config Key | Default Label | Default Multiplier | Default Duration | Badge Color |
|-----------|---------------|-------------------|-----------------|-------------|
| `rising` | Rising | 1.5x | 24 hours | Orange 🟠 |
| `viral` | Viral | 2.0x | 48 hours | Red 🔴 |
| `mega_viral` | Mega Viral | 3.0x | 72 hours | Purple 🟣 |
| (expired) | Expired | 1.0x | — | Gray ⚫ |

> All labels, multipliers, and durations are read from `viralThresholds[].label`, `.multiplier`, `.maxDurationHours`. Admin can rename, adjust multipliers, or add new tiers at any time.

### Widget Specifications

#### 1. `viral_badge.dart` — Post overlay
- **Position:** Top-right of post card
- **Animated:** Pulse effect for viral/mega_viral
- **Display:** 🔥 icon + status text + multiplier
- **Tap:** Opens `viral_score_breakdown` bottom sheet

#### 2. `trending_feed_view.dart`
- **Scrollable feed** of trending posts
- **Sort by:** Viral score, views, shares
- **Each card shows:** Post thumbnail, viral badge, score, metrics, author
- **Pull-to-refresh**

#### 3. `my_viral_posts_view.dart`
- **List of user's viral content** (current + historical)
- **Per item:** Status badge, viral score, multiplier, bonus earned, metrics
- **Empty state:** Tips to create viral content

---

## PHASE 5 — ANTI-ABUSE & RISK SYSTEM <a id="phase-5"></a>

**Priority:** 🟡 MEDIUM | **Effort:** Small-Medium | **Backend Required:** None  
**Depends on:** Phase 0 (config service for anti-abuse thresholds)  
**Status:** ✅ COMPLETED

### Overview
Warning banners, account standing, and appeal functionality to protect creators.

### ⚠️ Dynamic Config Requirement
- **Risk score thresholds** (fake score, auto-freeze threshold) — from `EarningConfigService.antiAbuse`
- **Scan frequency** display — from config
- **Feature visibility** — risk indicators hidden if `antiAbuse.fakeDetectionEnabled == false`
- **Do NOT hardcode** risk level boundaries (e.g., "50 = medium") — use thresholds from API

### Files to Create

```
lib/app/modules/antiAbuse/
├── widgets/
│   ├── account_warning_banner.dart          ← NEW: Global warning banner
│   ├── earning_frozen_banner.dart           ← NEW: Frozen earnings alert
│   ├── account_standing_sheet.dart          ← NEW: Standing detail sheet
│   ├── appeal_form_sheet.dart               ← NEW: Appeal submission
│   ├── duplicate_content_warning.dart       ← NEW: Post creation warning
│   └── rate_limit_warning.dart              ← NEW: Toast/snackbar
├── models/
│   └── anti_abuse_models.dart               ← NEW
└── services/
    └── anti_abuse_api_service.dart           ← NEW
```

### Files to Modify
- `earn_dashboard_view.dart` — Show warning/frozen banners at top
- Post creation flow — Add duplicate content check
- Main scaffold — Add global warning banner capability

### Risk Levels & Colors (Admin-Configured)

Risk level boundaries come from `EarningConfigService.antiAbuse` config. **Do NOT hardcode** the score ranges.

| Level | Default Range | Color | Action |
|-------|--------------|-------|--------|
| Low | 0–(fakeScoreThreshold-1) | Green | No action |
| Medium | fakeScoreThreshold–(autoFreezeThreshold-1) | Yellow | Warning banner shown |
| High | autoFreezeThreshold–89 | Orange | Earnings reduced, appeal available |
| Critical | 90–100 | Red | Earnings frozen, immediate appeal required |

> `fakeScoreThreshold` and `autoFreezeThreshold` are admin-configured via `page_anti_abuse` config section.

### Widget Specifications

#### 1. `account_warning_banner.dart`
- **Dismissible** yellow/orange banner at top of earning dashboard
- **Message:** "Unusual activity detected on your account"
- **CTA:** "View Details" → Opens account standing sheet
- **Auto-shows** based on risk check on dashboard load

#### 2. `earning_frozen_banner.dart`
- **Non-dismissible** red banner
- **Message:** "Your earnings are frozen pending review"
- **CTA:** "Submit Appeal" → Opens appeal form
- **Shows frozen amount**

#### 3. `appeal_form_sheet.dart`
- **Bottom sheet** with:
  - Reason selector (dropdown)
  - Explanation text area (min 50 chars)
  - Evidence attachment (optional image upload)
  - Submit button
- **API:** `POST /api/anti-abuse/appeal`

---

## PHASE 6 — TIPPING & DONATIONS SYSTEM <a id="phase-6"></a>

**Priority:** 🟡 MEDIUM | **Effort:** Large | **Backend Required:** None (APIs exist)  
**Status:** ✅ COMPLETED

### Overview
Allow users to send/receive tips, set goals, track supporters.

### Files to Create

```
lib/app/modules/tipping/
├── bindings/
│   └── tipping_binding.dart                 ← NEW
├── controllers/
│   └── tipping_controller.dart              ← NEW
├── views/
│   └── tip_dashboard_view.dart              ← NEW: 5-tab dashboard
├── widgets/
│   ├── tip_button.dart                      ← NEW: Profile/post button
│   ├── tip_modal.dart                       ← NEW: Amount selection sheet
│   ├── tip_animation.dart                   ← NEW: Lottie/Rive coin animation
│   ├── tip_received_toast.dart              ← NEW: Notification overlay
│   ├── top_supporters.dart                  ← NEW: Top supporters list
│   ├── tip_goal_progress.dart               ← NEW: Goal progress bar
│   ├── tip_goal_form.dart                   ← NEW: Set/edit goal
│   ├── tip_history.dart                     ← NEW: Transaction history
│   ├── tip_summary_card.dart                ← NEW: Overview card
│   └── supporter_badge.dart                 ← NEW: Reusable badge
├── models/
│   └── tipping_models.dart                  ← NEW
└── services/
    └── tipping_api_service.dart             ← NEW
```

### Files to Modify
- `app_routes.dart` — Add `/tip-dashboard` route
- `profile_view.dart` — Add tip button on other users' profiles
- Post cards — Add tip button option
- Socket service — Listen for real-time tip notifications

### API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `POST /api/tips/send` | POST | Send a tip |
| `GET /api/tips/history?type=sent\|received` | GET | Tip history |
| `GET /api/tips/summary` | GET | Overview (total received, sent, supporters count) |
| `GET /api/tips/supporters` | GET | Top supporters list |
| `GET /api/tips/goals` | GET | Active tip goals |
| `POST /api/tips/goals` | POST | Create/update tip goal |
| `DELETE /api/tips/goals/:id` | DELETE | Remove tip goal |

### Tip Dashboard Tabs
1. **Overview** — Total received, total sent, top supporter, active goal
2. **Received** — List of tips received (amount, from, date, message)
3. **Sent** — List of tips sent (amount, to, date)
4. **Supporters** — Ranked list of supporters (total amount, tip count, badge)
5. **Goal** — Active goal progress, goal form

---

## PHASE 7 — PROFILE & PAGE BADGE INTEGRATION <a id="phase-7"></a>

**Priority:** 🔴 HIGH | **Effort:** Small | **Backend Required:** None  
**Status:** ✅ COMPLETED

### Overview
Integrate all tier badges, earning indicators, and monetization CTAs into existing profile and page screens.

### Files to Modify

#### User Profile (`profile_view.dart`)
1. **Creator Tier Badge** — Next to username (from Phase 3)
2. **Earning Summary Mini-Card** — Below profile info:
   - Today's estimate | Tier | Streak days | Rank
   - Tap → Navigate to earning dashboard
3. **Account Standing Indicator** — If risk > 25, show warning icon
4. **Tip button** — For visiting other users' profiles

#### Page Profile (`page_profile_view.dart`)
1. **Page Tier Badge** — Next to page name (from Phase 2)
2. **Monetization Status Indicator** — Near follow/like buttons
   - Green dot: Monetized & active
   - Yellow dot: Pending review
   - Red dot: Suspended
   - No dot: Not applied
3. **"Monetize This Page" CTA** — For page owners (if not yet monetized)
4. **Page Earning Mini-Card** — For page owners:
   - Today's page score | Tier | % of total earnings
   - Tap → Navigate to page monetization dashboard

#### Earning Dashboard (`earn_dashboard_view.dart`)
1. **Enhance PageBreakdownCard** — Add tier badges + viral indicators per page
2. **Enhance TodayEstimateCard** — Show creator tier multiplier badge
3. **Warning banners** — Show at top if anti-abuse flags exist

#### My Pages List (`my_pages_view.dart`)
1. **Monetization status dots** next to each page name
2. **Tier label** in page list item subtitle

### Rulebook Enhancements (`earning_guide_view.dart`)
**Handled in Phase 0.** The 3 missing sections (Page Monetization, Creator Tiers, Viral Bonuses) are added as part of the dynamic config conversion. They use `EarningConfigService` and are conditionally shown based on `enabled` flags.

Additional integration after Phases 2-4:
- Link from Page Monetization rulebook section → Page Monetization dashboard
- Link from Creator Tiers section → Creator Dashboard
- Link from Viral Bonuses section → Trending Feed

---

## PHASE 8 — WALLET ENHANCEMENTS <a id="phase-8"></a>

**Priority:** 🟢 LOW | **Effort:** Small | **Backend Required:** None  
**Status:** ✅ COMPLETED

### Overview
Enhance wallet with features matching web (minimum threshold progress, cooling info, checklist).

### Enhancements to `wallet_balance_card.dart`

1. **Withdrawal Readiness Checklist:**
   - ✅ Balance ≥ $250
   - ✅ Stripe account connected
   - ✅ Identity verified
   - ✅ No pending withdrawal
   - ✅ 24hr cooldown passed

2. **Progress bar** to $250 minimum threshold

3. **Recent withdrawals** with expandable status (pending → processing → completed / failed)

4. **Recent daily earnings** quick list (last 5 days)

---

## ARCHITECTURE & TECHNICAL GUIDELINES <a id="architecture"></a>

### State Management
- **GetX** (consistent with existing codebase)
- Each module has: `Binding` → `Controller` → `View` + `Widgets`
- Reactive state with `.obs` and `Obx()` widgets
- `GetConnect` or existing Dio-based API service

### API Integration Pattern
```dart
// Follow existing pattern from earning_api_service.dart
class PageMonetizationApiService {
  final DioClient _dio;  // Use existing DioClient

  Future<ApiResponse<PageEligibility>> checkEligibility(String pageId) async {
    try {
      final response = await _dio.get('/api/page-monetization/eligibility/$pageId');
      if (response.data['success'] == true) {
        return ApiResponse.success(PageEligibility.fromJson(response.data['data']));
      }
      return ApiResponse.error(response.data['message']);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
```

### UI Patterns
- **Cards:** Use existing card pattern from earning dashboard widgets
- **Bottom Sheets:** For detail views and forms (existing pattern: `DailyBreakdownBottomSheet`)
- **Badges:** Small reusable widgets with size variants
- **Charts:** `fl_chart` package (check if already in pubspec, add if not)
- **Animations:** Lottie for tip animations (add `lottie` package)
- **Colors:** Follow existing theme system from `lib/app/core/theme/`
- **Responsive:** Use `MediaQuery` + `LayoutBuilder` for tablet support

### Navigation Pattern
```dart
// Routes
static const PAGE_MONETIZATION = '/page-monetization';
static const CREATOR_DASHBOARD = '/creator-dashboard';
static const TRENDING = '/trending';
static const TIP_DASHBOARD = '/tip-dashboard';
```

### Error Handling
- Show `SnackBar` for API errors
- Skeleton loading while fetching
- Pull-to-refresh on all list views
- Retry buttons on error states
- Offline caching for badge/tier data (Hive or GetStorage)

### 🔴 Dynamic Config Pattern (MANDATORY for all modules)

```dart
// CORRECT — Read from global config service
final configService = Get.find<EarningConfigService>();

Obx(() {
  final tierEnabled = configService.tierEnabled;
  if (!tierEnabled) return SizedBox.shrink();
  
  final tiers = configService.userTiers;
  return Column(
    children: tiers.map((t) => TierBadge(
      label: t.label,         // ✅ From API
      multiplier: t.multiplier, // ✅ From API
      color: _colorForKey(t.key),
    )).toList(),
  );
})

// WRONG — Never do this
Text('Growth Tier: 1.5x multiplier')  // ❌ Hardcoded
Text('Minimum 1000 followers')        // ❌ Hardcoded
Text('Streak bonus: +10%')             // ❌ Hardcoded
```

**Config-driven visibility pattern:**
```dart
// Feature sections should show/hide based on admin config flags
Obx(() {
  if (!configService.pageMonetizationEnabled) return SizedBox.shrink();
  return PageMonetizationSection(...);
})
```

**Fallback pattern (for offline / first launch):**
```dart
// Always provide defaults — but make clear they are fallbacks
final revenueShare = configService.revenueSharePercent; // Returns 50.0 as fallback
// Config service handles: API value > Cached value > Default value
```

---

## API ENDPOINT REFERENCE — COMPLETE <a id="api-reference"></a>

### Existing Endpoints (Already Integrated in Mobile)

| Endpoint | Module |
|----------|--------|
| `GET /api/earning/dashboard-data` | Earning Dashboard |
| `GET /api/earning/today-estimate` | Earning Dashboard |
| `GET /api/earning/top10-leaderboard` | Earning Dashboard |
| `GET /api/earning/my-ranking` | Earning Dashboard |
| `GET /api/earning/score-weights` | Earning Dashboard |
| `GET /api/earning/daily-earnings` | Earning Dashboard |
| `GET /api/earning/daily-breakdown/:date` | Earning Dashboard |
| `GET /api/earning/page-breakdown` | Earning Dashboard |
| `GET /api/earning/platform-stats` | Earning Dashboard |
| `GET /api/earnings-wallet/summary` | Wallet |
| `POST /api/earnings-wallet/stripe/connect` | Wallet |
| `GET /api/earnings-wallet/stripe/onboarding-link` | Wallet |
| `POST /api/earnings-wallet/withdraw` | Wallet |

### New Endpoints to Integrate

**Revenue Analytics (Phase 1):**

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/revenue-analytics/trends` | GET | Earning trends (period: 7d/30d/90d/custom) |
| `/api/revenue-analytics/content-earnings` | GET | Per-content earnings (period filter) |
| `/api/revenue-analytics/score-optimizer` | GET | Activity recommendations |
| `/api/revenue-analytics/forecast` | GET | Projected earnings |

**Page Monetization (Phase 2):**

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/page-monetization/eligibility/:pageId` | GET | Eligibility check |
| `/api/page-monetization/apply/:pageId` | POST | Submit application |
| `/api/page-monetization/status/:pageId` | GET | Application status |
| `/api/page-monetization/my-pages` | GET | User's pages + monetization status |
| `/api/page-monetization/tier/:pageId` | GET | Tier info + multiplier |
| `/api/page-monetization/tier-history/:pageId` | GET | Tier progression |
| `/api/page-monetization/viral/:pageId` | GET | Viral content list |
| `/api/page-monetization/risk/:pageId` | GET | Risk profile |

**Creator Tier (Phase 3):**

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/creator/my-tier` | GET | Current tier + dimensions |
| `/api/creator/eligibility` | GET | Creator eligibility |
| `/api/creator/apply` | POST | Apply for creator program |
| `/api/creator/application-status` | GET | Application tracking |
| `/api/creator/priority-score` | GET | Priority score detail |
| `/api/creator/tier-history` | GET | Tier change history |

**Viral Content (Phase 4):**

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/viral/trending` | GET | Trending posts feed |
| `/api/viral/my-posts` | GET | User's viral posts |
| `/api/viral/post/:id` | GET | Single post viral status |
| `/api/viral/score/:id` | GET | Viral score breakdown |

**Tipping (Phase 6):**

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/tips/send` | POST | Send a tip |
| `/api/tips/history` | GET | Tip history (type filter) |
| `/api/tips/summary` | GET | Tip overview |
| `/api/tips/supporters` | GET | Supporter list |
| `/api/tips/goals` | GET | Active goals |
| `/api/tips/goals` | POST | Create/update goal |
| `/api/tips/goals/:id` | DELETE | Remove goal |

---

## TESTING STRATEGY <a id="testing"></a>

### Unit Tests
- Model serialization tests (fromJson/toJson for all new models)
- Controller logic tests (state transitions, error handling)
- API service mock tests

### Widget Tests
- Badge rendering (all sizes, all tiers)
- Form validation (application forms, appeal form)
- Empty states and loading states

### Integration Tests
- Full flow: Check eligibility → Apply → Track status
- Full flow: View analytics → Change period → Verify chart updates
- Full flow: Send tip → Verify toast → Check history

### Manual Testing Checklist
- [ ] Analytics charts render correctly with real data
- [ ] Page monetization flow (apply, pending, approved)
- [ ] Creator tier badge shows correctly on profile
- [ ] Viral badges show on posts in feed
- [ ] Warning banners appear for flagged accounts
- [ ] Tip flow works end-to-end
- [ ] All badges render at correct sizes
- [ ] Pull-to-refresh works on all new screens
- [ ] Error states display correctly
- [ ] Offline mode doesn't crash

---

## ROLLOUT PLAN <a id="rollout"></a>

### Implementation Order (Recommended)

| Phase | Feature | Priority | Effort | Dependencies |
|-------|---------|----------|--------|-------------|
| **0** | **Dynamic Config Foundation** | 🔴🔴 CRITICAL | 1 week | **MUST BE FIRST** — all other phases depend on this |
| **1** | Earning Analytics Dashboard | 🔴 HIGH | 2 weeks | Phase 0 (config service) |
| **7a** | Profile Badge Integration (basic) | 🔴 HIGH | 3 days | Phase 0 |
| **2** | Page Monetization System | 🔴 HIGH | 3 weeks | Phase 0 + 7a for badge integration |
| **3** | Creator Tier System | 🔴 HIGH | 2 weeks | Phase 0 + 7a for badge integration |
| **5** | Anti-Abuse & Risk System | 🟡 MEDIUM | 1 week | Phase 0 + 2 for page risk |
| **4** | Viral Content System | 🟡 MEDIUM | 2 weeks | Phase 0 + 2 for page viral |
| **6** | Tipping System | 🟡 MEDIUM | 2.5 weeks | Socket service update |
| **7b** | Full Profile Integration (all) | 🟡 MEDIUM | 1 week | Phase 2-6 complete |
| **8** | Wallet Enhancements | 🟢 LOW | 3 days | Phase 0 |

### Total Estimated Scope
- **~70 new Dart files** across 7 new modules + modifications to 15+ existing files
- **30+ new API integrations** (all endpoints already exist in backend)
- **15+ new data models** + 1 global config model
- **0 backend changes required**
- **1 major refactor** of existing static guide to dynamic

### Feature Flags — Admin-Driven (NOT Local Constants)
```dart
// ❌ WRONG — local feature flags defeat the purpose of admin control
class FeatureFlags {
  static const bool enableCreatorTier = true;  // ❌ Hardcoded
}

// ✅ CORRECT — feature visibility driven by admin config from API
final configService = Get.find<EarningConfigService>();
if (configService.tierEnabled) { /* show tier UI */ }
if (configService.viralEnabled) { /* show viral UI */ }
if (configService.pageMonetizationEnabled) { /* show page monetization */ }
// Admin toggles features on/off in qp-admin → UI reflects instantly
```

### Milestone Checkpoints

| Milestone | Phases | Validation |
|-----------|--------|-----------|
| **M0: Config Foundation** | 0 | All static values replaced with API config; guide shows dynamic data; admin config changes reflect in mobile |
| **M1: Analytics & Badges** | 1, 7a | Analytics tab works, badges show on profiles |
| **M2: Page Monetization** | 2 | Full page monetization flow, dynamic eligibility & tier display |
| **M3: Creator Economy** | 3, 5 | Creator tiers + anti-abuse banners work, all from config |
| **M4: Social Features** | 4, 6 | Viral badges + tipping fully functional |
| **M5: Polish & Parity** | 7b, 8 | All integrations complete, wallet enhanced |

---

## FILE SUMMARY — ALL NEW FILES

| # | File | Phase | Type |
|---|------|-------|------|
| 1 | `earnDashboard/models/earning_config_model.dart` | **0** | **Config Model** |
| 2 | `earnDashboard/services/earning_config_service.dart` | **0** | **Global Service** |
| 3 | `earnDashboard/views/earning_analytics_view.dart` | 1 | View |
| 4 | `earnDashboard/widgets/analytics/earnings_trend_chart.dart` | 1 | Widget |
| 5 | `earnDashboard/widgets/analytics/period_compare_card.dart` | 1 | Widget |
| 6 | `earnDashboard/widgets/analytics/rank_tracker_card.dart` | 1 | Widget |
| 7 | `earnDashboard/widgets/analytics/content_earnings_card.dart` | 1 | Widget |
| 8 | `earnDashboard/widgets/analytics/score_optimizer_card.dart` | 1 | Widget |
| 9 | `earnDashboard/widgets/analytics/earning_forecast_card.dart` | 1 | Widget |
| 10 | `earnDashboard/model/analytics_models.dart` | 1 | Model |
| 11 | `pageMonetization/bindings/page_monetization_binding.dart` | 2 | Binding |
| 12 | `pageMonetization/controllers/page_monetization_controller.dart` | 2 | Controller |
| 11 | `pageMonetization/views/page_monetization_view.dart` | 2 | View |
| 12 | `pageMonetization/views/page_monetization_detail_view.dart` | 2 | View |
| 13 | `pageMonetization/widgets/page_eligibility_card.dart` | 2 | Widget |
| 14 | `pageMonetization/widgets/page_application_form.dart` | 2 | Widget |
| 15 | `pageMonetization/widgets/page_application_status.dart` | 2 | Widget |
| 16 | `pageMonetization/widgets/page_earning_overview.dart` | 2 | Widget |
| 17 | `pageMonetization/widgets/page_tier_badge.dart` | 2 | Widget |
| 18 | `pageMonetization/widgets/page_tier_progress.dart` | 2 | Widget |
| 19 | `pageMonetization/widgets/page_viral_history.dart` | 2 | Widget |
| 20 | `pageMonetization/widgets/page_risk_indicator.dart` | 2 | Widget |
| 21 | `pageMonetization/models/page_monetization_models.dart` | 2 | Model |
| 22 | `pageMonetization/services/page_monetization_api_service.dart` | 2 | Service |
| 23 | `creatorTier/bindings/creator_tier_binding.dart` | 3 | Binding |
| 24 | `creatorTier/controllers/creator_tier_controller.dart` | 3 | Controller |
| 25 | `creatorTier/views/creator_dashboard_view.dart` | 3 | View |
| 26 | `creatorTier/widgets/creator_tier_badge.dart` | 3 | Widget |
| 27 | `creatorTier/widgets/tier_progress_card.dart` | 3 | Widget |
| 28 | `creatorTier/widgets/eligibility_card.dart` | 3 | Widget |
| 29 | `creatorTier/widgets/application_form.dart` | 3 | Widget |
| 30 | `creatorTier/widgets/application_status.dart` | 3 | Widget |
| 31 | `creatorTier/widgets/priority_score_breakdown.dart` | 3 | Widget |
| 32 | `creatorTier/widgets/tier_history_card.dart` | 3 | Widget |
| 33 | `creatorTier/models/creator_tier_models.dart` | 3 | Model |
| 34 | `creatorTier/services/creator_tier_api_service.dart` | 3 | Service |
| 35 | `viralContent/bindings/viral_content_binding.dart` | 4 | Binding |
| 36 | `viralContent/controllers/viral_content_controller.dart` | 4 | Controller |
| 37 | `viralContent/views/trending_feed_view.dart` | 4 | View |
| 38 | `viralContent/views/my_viral_posts_view.dart` | 4 | View |
| 39 | `viralContent/widgets/viral_badge.dart` | 4 | Widget |
| 40 | `viralContent/widgets/rising_badge.dart` | 4 | Widget |
| 41 | `viralContent/widgets/viral_score_breakdown.dart` | 4 | Widget |
| 42 | `viralContent/widgets/viral_bonus_toast.dart` | 4 | Widget |
| 43 | `viralContent/widgets/trending_card.dart` | 4 | Widget |
| 44 | `viralContent/models/viral_content_models.dart` | 4 | Model |
| 45 | `viralContent/services/viral_api_service.dart` | 4 | Service |
| 46 | `antiAbuse/widgets/account_warning_banner.dart` | 5 | Widget |
| 47 | `antiAbuse/widgets/earning_frozen_banner.dart` | 5 | Widget |
| 48 | `antiAbuse/widgets/account_standing_sheet.dart` | 5 | Widget |
| 49 | `antiAbuse/widgets/appeal_form_sheet.dart` | 5 | Widget |
| 50 | `antiAbuse/widgets/duplicate_content_warning.dart` | 5 | Widget |
| 51 | `antiAbuse/widgets/rate_limit_warning.dart` | 5 | Widget |
| 52 | `antiAbuse/models/anti_abuse_models.dart` | 5 | Model |
| 53 | `antiAbuse/services/anti_abuse_api_service.dart` | 5 | Service |
| 54 | `tipping/bindings/tipping_binding.dart` | 6 | Binding |
| 55 | `tipping/controllers/tipping_controller.dart` | 6 | Controller |
| 56 | `tipping/views/tip_dashboard_view.dart` | 6 | View |
| 57 | `tipping/widgets/tip_button.dart` | 6 | Widget |
| 58 | `tipping/widgets/tip_modal.dart` | 6 | Widget |
| 59 | `tipping/widgets/tip_animation.dart` | 6 | Widget |
| 60 | `tipping/widgets/tip_received_toast.dart` | 6 | Widget |
| 61 | `tipping/widgets/top_supporters.dart` | 6 | Widget |
| 62 | `tipping/widgets/tip_goal_progress.dart` | 6 | Widget |
| 63 | `tipping/widgets/tip_goal_form.dart` | 6 | Widget |
| 64 | `tipping/widgets/tip_history.dart` | 6 | Widget |
| 65 | `tipping/widgets/tip_summary_card.dart` | 6 | Widget |
| 66 | `tipping/widgets/supporter_badge.dart` | 6 | Widget |
| 67 | `tipping/models/tipping_models.dart` | 6 | Model |
| 68 | `tipping/services/tipping_api_service.dart` | 6 | Service |

**Total: 70 new files + ~15 file modifications**

---

> **🔴 CRITICAL REMINDER:** All configuration values (score weights, multipliers, thresholds, tier  
> names, eligibility criteria, viral rules, anti-abuse settings) MUST be loaded dynamically  
> from the admin-managed `RevenueShareConfig` via `/api/earning/score-weights` endpoint.  
> **NEVER hardcode** values that admins can change. The `EarningConfigService` (Phase 0)  
> is the single source of truth for all config-driven UI across the entire app.  
>  
> **Data flow:** Admin (qp-admin) → RevenueShareConfig (MongoDB) → API → EarningConfigService → All Widgets  
>  
> No backend development is required. This plan is purely frontend (Flutter) implementation.  
> Refer to `qp-web/yuvi-wrk/Monetization/` for detailed web implementation docs.
