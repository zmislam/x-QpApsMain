import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/constants/color.dart';
import '../services/earning_config_service.dart';
import '../../../routes/app_pages.dart';

/// Earning Guide / Rulebook — ALL values are DYNAMIC from admin config.
/// Uses EarningConfigService (GetxService) for reactive updates via Obx().
class EarningGuideView extends StatefulWidget {
  const EarningGuideView({super.key});

  @override
  State<EarningGuideView> createState() => _EarningGuideViewState();
}

class _EarningGuideViewState extends State<EarningGuideView> {
  final ScrollController _scrollController = ScrollController();
  final EarningConfigService _cfg = Get.find<EarningConfigService>();
  int _activeSection = 0;

  // Base sections (always shown)
  final List<_Section> _baseSections = [
    _Section('overview', 'Overview', Icons.info_outline),
    _Section('how-it-works', 'How It Works', Icons.settings),
    _Section('earning-activities', 'Activities', Icons.star_outline),
    _Section('bonuses', 'Bonuses', Icons.local_fire_department),
    _Section('distribution', 'Distribution', Icons.pie_chart_outline),
    _Section('eligibility', 'Eligibility', Icons.verified_user_outlined),
  ];

  // Dynamic sections (shown based on feature flags)
  final _Section _pageMonetizationSection =
      _Section('page-monetization', 'Pages', Icons.storefront);
  final _Section _tierSection =
      _Section('creator-tiers', 'Tiers', Icons.workspace_premium);
  final _Section _viralSection =
      _Section('viral-bonuses', 'Viral', Icons.trending_up);

  // Always-shown trailing sections
  final List<_Section> _trailingSections = [
    _Section('tips', 'Tips', Icons.lightbulb_outline),
    _Section('faq', 'FAQ', Icons.help_outline),
  ];

  final Map<String, GlobalKey> _sectionKeys = {};

  List<_Section> get _sections {
    final list = [..._baseSections];
    if (_cfg.pageMonetizationEnabled) list.add(_pageMonetizationSection);
    if (_cfg.tierEnabled) list.add(_tierSection);
    if (_cfg.viralEnabled) list.add(_viralSection);
    list.addAll(_trailingSections);
    return list;
  }

  @override
  void initState() {
    super.initState();
    // Pre-register all possible section keys
    final allPossible = [
      ..._baseSections,
      _pageMonetizationSection,
      _tierSection,
      _viralSection,
      ..._trailingSections,
    ];
    for (var s in allPossible) {
      _sectionKeys[s.id] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    final sections = _sections;
    if (index >= sections.length) return;
    final key = _sectionKeys[sections[index].id];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(key!.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut);
    }
    setState(() => _activeSection = index);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Re-evaluate sections whenever config changes
      final sections = _sections;

      return Column(
        children: [
          // Sticky section tabs
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: sections.length,
              itemBuilder: (context, i) {
                final active = _activeSection == i;
                return GestureDetector(
                  onTap: () => _scrollToSection(i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              active ? PRIMARY_COLOR : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(sections[i].icon,
                            size: 14,
                            color: active
                                ? PRIMARY_COLOR
                                : Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(sections[i].label,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: active
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: active
                                    ? PRIMARY_COLOR
                                    : Colors.grey.shade600)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick stats banner (DYNAMIC)
                  _quickStatsBanner(),
                  const SizedBox(height: 16),

                  // Section 1: Overview
                  _buildOverviewSection(),

                  // Section 2: How It Works
                  _buildHowItWorksSection(),

                  // Section 3: Earning Activities (DYNAMIC)
                  _buildEarningActivitiesSection(),

                  // Section 4: Bonuses (DYNAMIC)
                  _buildBonusesSection(),

                  // Section 5: Distribution (DYNAMIC)
                  _buildDistributionSection(),

                  // Section 6: Eligibility (DYNAMIC)
                  _buildEligibilitySection(),

                  // Section 7: Page Monetization (DYNAMIC, conditional)
                  if (_cfg.pageMonetizationEnabled)
                    _buildPageMonetizationSection(),

                  // Section 8: Creator Tiers (DYNAMIC, conditional)
                  if (_cfg.tierEnabled) _buildCreatorTiersSection(),

                  // Section 9: Viral Bonuses (DYNAMIC, conditional)
                  if (_cfg.viralEnabled) _buildViralBonusesSection(),

                  // Tips section
                  _buildTipsSection(),

                  // FAQ section (DYNAMIC values in answers)
                  _buildFaqSection(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  // ─────────────────────────────────────────────────
  // SECTION BUILDERS (all reading from _cfg dynamically)
  // ─────────────────────────────────────────────────

  Widget _buildOverviewSection() {
    final timeStr = _cfg.distributionTimeFormatted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('overview', 'Welcome to the Earning Program'),
        const SizedBox(height: 8),
        _infoText(
            'Our revenue sharing program rewards you for being an active member. Every interaction counts — your activity earns you real money from our ad revenue.'),
        const SizedBox(height: 12),
        _principleCard(Icons.attach_money, 'Real Money',
            'Earn real USD from platform ad revenue — not tokens or credits.'),
        _principleCard(Icons.balance, 'Fair Distribution',
            'Your share is proportional to your activity score relative to all users.'),
        _principleCard(Icons.schedule, 'Daily Payouts',
            'Earnings are calculated and credited every day at $timeStr.'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHowItWorksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('how-it-works', 'How It Works'),
        const SizedBox(height: 8),
        _stepCard(1, 'Engage Naturally',
            'Use the platform as you normally would — react, comment, share, post.'),
        _stepCard(2, 'Points Calculated',
            'Your daily activity is converted into points using our scoring system.'),
        _stepCard(3, 'Pool Share',
            'Your points determine your share of the daily creator pool.'),
        _stepCard(4, 'Earnings Credited',
            'Your USD earnings are credited to your wallet daily at ${_cfg.distributionTimeFormatted}.'),
        const SizedBox(height: 8),
        _codeBlock(
            'Your Earning = (Your Points / Total Points) × Creator Pool'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEarningActivitiesSection() {
    final sw = _cfg.scoreWeights;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
            'earning-activities', 'Earning Activities & Point Values'),
        const SizedBox(height: 8),
        _subHeader('Creator Points (Content You Create)'),
        _scoreRow('Post Reaction Received',
            '+${_fmtWeight(sw['post_reaction_received'] ?? 1.0)}'),
        _scoreRow('Post Comment Received',
            '+${_fmtWeight(sw['post_comment_received'] ?? 2.0)}'),
        _scoreRow('Post Share Received',
            '+${_fmtWeight(sw['post_share_received'] ?? 3.0)}'),
        _scoreRow('Reel View Received',
            '+${_fmtWeight(sw['reel_view_received'] ?? 0.5)}'),
        _scoreRow('Story View Received',
            '+${_fmtWeight(sw['story_view_received'] ?? 0.3)}'),
        const SizedBox(height: 12),
        _subHeader('User Points (Your Activity)'),
        _scoreRow('Give Reaction',
            '+${_fmtWeight(sw['reaction_given'] ?? 0.2)}'),
        _scoreRow('Give Comment',
            '+${_fmtWeight(sw['comment_given'] ?? 0.5)}'),
        _scoreRow('Share Content',
            '+${_fmtWeight(sw['share_given'] ?? 0.3)}'),
        const SizedBox(height: 12),
        _subHeader('Campaign Points'),
        _scoreRow('Ad Impression',
            '+${_fmtWeight(sw['campaign_impression'] ?? 0.1)}'),
        _scoreRow('Ad Click',
            '+${_fmtWeight(sw['campaign_click'] ?? 0.5)}'),
        _scoreRow('Ad Reaction',
            '+${_fmtWeight(sw['campaign_reaction'] ?? 1.5)}'),
        _scoreRow('Ad Comment',
            '+${_fmtWeight(sw['campaign_comment'] ?? 2.5)}'),
        _scoreRow('Ad Share',
            '+${_fmtWeight(sw['campaign_share'] ?? 4.0)}'),
        _scoreRow('Watch Ad 10s+',
            '+${_fmtWeight(sw['campaign_watch_10sec'] ?? 2.0)}'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBonusesSection() {
    final bm = _cfg.bonusMultipliers;
    final t1 = _cfg.streakTier1Days;
    final t2 = _cfg.streakTier2Days;
    final t3 = _cfg.streakTier3Days;
    final streak1Pct = ((bm['streak_7_days'] ?? 0.10) * 100).toInt();
    final streak2Pct = ((bm['streak_30_days'] ?? 0.25) * 100).toInt();
    final streak3Pct = ((bm['streak_90_days'] ?? 0.50) * 100).toInt();
    final verifiedPct = ((bm['verified_creator'] ?? 0.15) * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('bonuses', 'Bonuses & Multipliers'),
        const SizedBox(height: 8),
        _infoText(
            'Stay active consistently and earn bonus multipliers on top of your base score!'),
        const SizedBox(height: 8),
        _bonusTierRow('$t1-Day Streak', '+$streak1Pct%', Colors.blue),
        _bonusTierRow('$t2-Day Streak', '+$streak2Pct%', Colors.orange),
        _bonusTierRow('$t3-Day Streak', '+$streak3Pct%', Colors.red),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: PRIMARY_COLOR.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: PRIMARY_COLOR.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              const Icon(Icons.verified,
                  color: PRIMARY_COLOR, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    'Verified Creator Bonus: +$verifiedPct%',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        _infoText(
            'Bonuses stack — a verified creator with a $t2-day streak gets +${streak2Pct + verifiedPct}% bonus!'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDistributionSection() {
    final pct = _cfg.revenueSharePercent.toInt();
    final platformPct = 100 - pct;
    final capPct = _cfg.maxUserSharePercent.toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('distribution', 'Revenue Distribution'),
        const SizedBox(height: 8),
        _distributionSplitRow(pct, platformPct),
        const SizedBox(height: 12),
        _infoText(
            'Daily ad revenue is split $pct/$platformPct between the Creator Pool and Platform Operations.'),
        const SizedBox(height: 8),
        _stepCard(1, 'Revenue Collected',
            'Total ad revenue for the day is calculated.'),
        _stepCard(2, '$pct% Creator Pool',
            '$pct% of the revenue goes into the creator pool for distribution.'),
        _stepCard(3, 'Proportional Split',
            'Each user receives their share based on points. A $capPct% per-user cap applies.'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEligibilitySection() {
    final minAge = _cfg.minAccountAgeDays;
    final minScore = _cfg.minEngagementScore;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('eligibility', 'Eligibility Requirements'),
        const SizedBox(height: 8),
        _eligibilityRow(
            Icons.calendar_today, 'Account age $minAge+ days'),
        _eligibilityRow(
            Icons.toggle_on, 'Monetization enabled in settings'),
        _eligibilityRow(Icons.trending_up,
            'Minimum ${_fmtWeight(minScore)} point per day'),
        _eligibilityRow(
            Icons.person, 'Active, non-suspended account'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPageMonetizationSection() {
    final pm = _cfg.config.value?.pageMonetization;
    if (pm == null) return const SizedBox.shrink();
    final pageTiers = _cfg.pageTiers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('page-monetization', 'Page Monetization'),
        const SizedBox(height: 8),
        _infoText(
            'Pages can earn their own revenue share with enhanced multipliers.'),
        const SizedBox(height: 8),
        _ruleRow('Minimum Page Age', '${pm.minPageAgeDays} days'),
        _ruleRow('Minimum Followers', '${pm.minFollowers}'),
        _ruleRow('Minimum Monthly Views', '${pm.minMonthlyViews}'),
        _ruleRow('Min Content Count', '${pm.minContentCount} posts'),
        _ruleRow(
            'Min Engagement Rate', '${pm.minEngagementRate}%'),
        _ruleRow('Max Pages Per User', '${pm.maxPagesPerUser}'),
        if (pageTiers.isNotEmpty) ...[
          const SizedBox(height: 12),
          _subHeader('Page Tiers'),
          ...pageTiers.map((tier) => _tierRow(
              tier.label,
              '${tier.multiplier}x',
              tier.minScore,
              tier.maxScore)),
        ],
        const SizedBox(height: 12),
        _deepLinkButton('View Page Monetization Dashboard', Routes.PAGE_MONETIZATION),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCreatorTiersSection() {
    final tc = _cfg.config.value?.tierConfig;
    if (tc == null) return const SizedBox.shrink();
    final userTiers = _cfg.userTiers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('creator-tiers', 'Creator Tiers'),
        const SizedBox(height: 8),
        _infoText(
            'Earn more as you grow! Higher tiers = bigger multipliers.'),
        const SizedBox(height: 8),
        ...userTiers.map((tier) => _tierRow(
            tier.label,
            '${tier.multiplier}x',
            tier.minScore,
            tier.maxScore)),
        if (tc.userScoreWeights.isNotEmpty) ...[
          const SizedBox(height: 12),
          _subHeader('Scoring Dimensions'),
          ...tc.userScoreWeights.entries.map((e) => _dimensionRow(
              _formatDimensionKey(e.key),
              '${(e.value * 100).toInt()}%')),
        ],
        const SizedBox(height: 8),
        _ruleRow(
            'Evaluation Period', '${tc.evaluationPeriodDays} days'),
        _ruleRow(
            'Demotion Grace', '${tc.demotionGracePeriodDays} days'),
        const SizedBox(height: 12),
        _deepLinkButton('View Creator Tier Dashboard', Routes.CREATOR_DASHBOARD),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildViralBonusesSection() {
    final vc = _cfg.config.value?.viralConfig;
    if (vc == null) return const SizedBox.shrink();
    final thresholds = _cfg.viralThresholds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('viral-bonuses', 'Viral Bonuses'),
        const SizedBox(height: 8),
        _infoText(
            'Content that goes viral earns bonus multipliers automatically!'),
        const SizedBox(height: 8),
        ...thresholds.map((t) => _viralTierRow(
            t.label, '${t.multiplier}x', '${t.maxDurationHours}h')),
        const SizedBox(height: 8),
        _ruleRow('Detection Interval',
            'Every ${vc.detectionIntervalHours} hours'),
        _ruleRow(
            'Applies to Users', vc.applyToUsers ? 'Yes' : 'No'),
        _ruleRow(
            'Applies to Pages', vc.applyToPages ? 'Yes' : 'No'),
        const SizedBox(height: 12),
        _deepLinkButton('View Trending & Viral Content', Routes.TRENDING),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTipsSection() {
    final verifiedPct =
        ((_cfg.bonusMultipliers['verified_creator'] ?? 0.15) * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('tips', 'Pro Tips to Maximize Earnings'),
        const SizedBox(height: 8),
        _tipCard(true, 'Post quality content that gets engagement'),
        _tipCard(
            true, 'Engage with others — reactions, comments, shares'),
        _tipCard(
            true, 'Maintain daily streaks for bonus multipliers'),
        _tipCard(true, 'Run campaigns to earn campaign points'),
        _tipCard(
            true, 'Verify your creator account for +$verifiedPct%'),
        _tipCard(
            true, 'Check your dashboard daily to track progress'),
        const SizedBox(height: 8),
        _tipCard(false, 'Don\'t use bots or automation'),
        _tipCard(false, 'Don\'t spam or post low-quality content'),
        _tipCard(
            false, 'Don\'t create fake accounts for engagement'),
        _tipCard(
            false, 'Don\'t break your streak — you lose the bonus!'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFaqSection() {
    final pct = _cfg.revenueSharePercent.toInt();
    final capPct = _cfg.maxUserSharePercent.toInt();
    final minAge = _cfg.minAccountAgeDays;
    final minScore = _cfg.minEngagementScore;
    final verifiedPct =
        ((_cfg.bonusMultipliers['verified_creator'] ?? 0.15) * 100).toInt();
    final timeStr = _cfg.distributionTimeFormatted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('faq', 'Frequently Asked Questions'),
        const SizedBox(height: 8),
        _faqItem('When do I get paid?',
            'Earnings are calculated and credited daily at $timeStr. You can withdraw once your balance reaches \$50.'),
        _faqItem('Why am I not earning anything?',
            'Make sure monetization is enabled, your account is $minAge+ days old, and you earned at least ${_fmtWeight(minScore)} point today. Check your Activity Score on the dashboard.'),
        _faqItem('How is the creator pool calculated?',
            'The creator pool is $pct% of the day\'s total ad revenue. Your share = (Your Points / Total Points) × Creator Pool.'),
        _faqItem('What is the minimum withdrawal?',
            '\$50 USD. You need a connected and verified Stripe account to withdraw.'),
        _faqItem('Do Page earnings count too?',
            'Yes! If you manage Pages, engagement on your Page content earns points which contribute to your score.'),
        _faqItem('How do I maintain my streak?',
            'Earn at least ${_fmtWeight(minScore)} point per day. Any qualifying activity (reaction, comment, share, etc.) counts.'),
        _faqItem('What is the $capPct% cap?',
            'No single user can earn more than $capPct% of the daily creator pool. This ensures fair distribution among all participants.'),
        _faqItem('Can I have multiple accounts?',
            'No. Multi-accounting violates our terms of service and will result in suspension of all accounts.'),
        _faqItem('How do I get verified?',
            'Apply for creator verification through your account settings. Verified creators earn a +$verifiedPct% bonus on their score.'),
      ],
    );
  }

  // ─────────────────────────────────────────────────
  // HELPER WIDGETS
  // ─────────────────────────────────────────────────

  String _fmtWeight(double v) {
    return v == v.roundToDouble() ? v.toInt().toString() : v.toString();
  }

  String _formatDimensionKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) =>
            w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  Widget _quickStatsBanner() {
    final pct = _cfg.revenueSharePercent.toInt();
    final timeStr = _cfg.distributionTimeFormatted;
    final maxStreakPct =
        ((_cfg.bonusMultipliers['streak_90_days'] ?? 0.50) * 100).toInt();
    final verifiedPct =
        ((_cfg.bonusMultipliers['verified_creator'] ?? 0.15) * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PRIMARY_COLOR.withValues(alpha: 0.08),
            PRIMARY_COLOR.withValues(alpha: 0.03)
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: PRIMARY_COLOR.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _quickStat('$pct%', 'Rev Share'),
          _quickStatDivider(),
          _quickStat(timeStr, 'Payout'),
          _quickStatDivider(),
          _quickStat('+$maxStreakPct%', 'Max Streak'),
          _quickStatDivider(),
          _quickStat('+$verifiedPct%', 'Verified'),
        ],
      ),
    );
  }

  Widget _quickStat(String value, String label) {
    return Flexible(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: PRIMARY_COLOR),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(label,
              style:
                  TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _quickStatDivider() {
    return Container(
        width: 1, height: 28, color: Colors.grey.shade300);
  }

  Widget _sectionHeader(String id, String title) {
    return Container(
      key: _sectionKeys[id],
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87)),
    );
  }

  Widget _subHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700)),
    );
  }

  Widget _infoText(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 13, color: Colors.grey.shade600, height: 1.5));
  }

  Widget _principleCard(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: PRIMARY_COLOR),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(desc,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepCard(int step, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: PRIMARY_COLOR,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text('$step',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(desc,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _codeBlock(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text,
          style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: Color(0xFF94A3B8))),
    );
  }

  Widget _scoreRow(String activity, String points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(activity,
              style:
                  const TextStyle(fontSize: 13, color: Colors.black87)),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: PRIMARY_COLOR.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(points,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: PRIMARY_COLOR)),
          ),
        ],
      ),
    );
  }

  Widget _bonusTierRow(String label, String bonus, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(bonus,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ),
        ],
      ),
    );
  }

  Widget _distributionSplitRow(int creatorPct, int platformPct) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: PRIMARY_COLOR.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text('$creatorPct%',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: PRIMARY_COLOR)),
                const SizedBox(height: 2),
                Text('Creator Pool',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text('$platformPct%',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54)),
                const SizedBox(height: 2),
                Text('Platform',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _eligibilityRow(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13, color: Colors.black87)),
          ),
          Icon(Icons.check_circle,
              size: 16, color: Colors.green.shade400),
        ],
      ),
    );
  }

  Widget _ruleRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _tierRow(
      String label, String multiplier, int minScore, int maxScore) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PRIMARY_COLOR.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: PRIMARY_COLOR.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium,
              color: PRIMARY_COLOR, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                Text('Score: $minScore – $maxScore',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: PRIMARY_COLOR.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(multiplier,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: PRIMARY_COLOR)),
          ),
        ],
      ),
    );
  }

  Widget _dimensionRow(String label, String weight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: Colors.black87)),
          Text(weight,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700)),
        ],
      ),
    );
  }

  Widget _viralTierRow(
      String label, String multiplier, String duration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.trending_up,
              color: Colors.orange.shade700, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                Text('Up to $duration',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(multiplier,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange.shade800)),
          ),
        ],
      ),
    );
  }

  Widget _tipCard(bool isDo, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDo ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isDo ? Icons.check_circle : Icons.cancel,
              size: 16,
              color: isDo
                  ? Colors.green.shade600
                  : Colors.red.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13, color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _deepLinkButton(String label, String route) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Get.toNamed(route),
        icon: const Icon(Icons.open_in_new, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 13)),
        style: OutlinedButton.styleFrom(
          foregroundColor: PRIMARY_COLOR,
          side: BorderSide(color: PRIMARY_COLOR.withOpacity(0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }

  Widget _faqItem(String question, String answer) {
    return _AccordionWidget(question: question, answer: answer);
  }
}

class _AccordionWidget extends StatefulWidget {
  final String question;
  final String answer;

  const _AccordionWidget(
      {required this.question, required this.answer});

  @override
  State<_AccordionWidget> createState() => _AccordionWidgetState();
}

class _AccordionWidgetState extends State<_AccordionWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: _expanded
                ? PRIMARY_COLOR.withValues(alpha: 0.2)
                : Colors.grey.shade200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.question,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                  Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: Colors.grey.shade500),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, bottom: 12),
              child: Text(widget.answer,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.5)),
            ),
        ],
      ),
    );
  }
}

class _Section {
  final String id;
  final String label;
  final IconData icon;
  _Section(this.id, this.label, this.icon);
}
