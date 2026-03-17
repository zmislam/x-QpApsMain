import 'package:flutter/material.dart';
import '../../../config/constants/color.dart';

class EarningGuideView extends StatefulWidget {
  const EarningGuideView({super.key});

  @override
  State<EarningGuideView> createState() => _EarningGuideViewState();
}

class _EarningGuideViewState extends State<EarningGuideView> {
  final ScrollController _scrollController = ScrollController();
  int _activeSection = 0;

  final List<_Section> _sections = [
    _Section('overview', 'Overview', Icons.info_outline),
    _Section('how-it-works', 'How It Works', Icons.settings),
    _Section('earning-activities', 'Activities', Icons.star_outline),
    _Section('bonuses', 'Bonuses', Icons.local_fire_department),
    _Section('distribution', 'Distribution', Icons.pie_chart_outline),
    _Section('eligibility', 'Eligibility', Icons.verified_user_outlined),
    _Section('tips', 'Tips', Icons.lightbulb_outline),
    _Section('faq', 'FAQ', Icons.help_outline),
  ];

  final Map<String, GlobalKey> _sectionKeys = {};

  @override
  void initState() {
    super.initState();
    for (var s in _sections) {
      _sectionKeys[s.id] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[_sections[index].id];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(key!.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut);
    }
    setState(() => _activeSection = index);
  }

  @override
  Widget build(BuildContext context) {
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
            itemCount: _sections.length,
            itemBuilder: (context, i) {
              final active = _activeSection == i;
              return GestureDetector(
                onTap: () => _scrollToSection(i),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: active ? PRIMARY_COLOR : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(_sections[i].icon,
                          size: 14,
                          color: active
                              ? PRIMARY_COLOR
                              : Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(_sections[i].label,
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
                // Quick stats banner
                _quickStatsBanner(),
                const SizedBox(height: 16),

                // Section 1: Overview
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
                    'Earnings are calculated and credited every day at 12 AM UTC.'),
                const SizedBox(height: 20),

                // Section 2: How It Works
                _sectionHeader('how-it-works', 'How It Works'),
                const SizedBox(height: 8),
                _stepCard(1, 'Engage Naturally',
                    'Use the platform as you normally would — react, comment, share, post.'),
                _stepCard(2, 'Points Calculated',
                    'Your daily activity is converted into points using our scoring system.'),
                _stepCard(3, 'Pool Share',
                    'Your points determine your share of the daily creator pool.'),
                _stepCard(4, 'Earnings Credited',
                    'Your USD earnings are credited to your wallet daily at midnight UTC.'),
                const SizedBox(height: 8),
                _codeBlock(
                    'Your Earning = (Your Points / Total Points) × Creator Pool'),
                const SizedBox(height: 20),

                // Section 3: Earning Activities
                _sectionHeader(
                    'earning-activities', 'Earning Activities & Point Values'),
                const SizedBox(height: 8),
                _subHeader('Creator Points (Content You Create)'),
                _scoreRow('Post Reaction Received', '+1.0'),
                _scoreRow('Post Comment Received', '+2.0'),
                _scoreRow('Post Share Received', '+3.0'),
                _scoreRow('Reel View Received', '+0.5'),
                _scoreRow('Story View Received', '+0.3'),
                const SizedBox(height: 12),
                _subHeader('User Points (Your Activity)'),
                _scoreRow('Give Reaction', '+0.2'),
                _scoreRow('Give Comment', '+0.5'),
                _scoreRow('Share Content', '+0.3'),
                const SizedBox(height: 12),
                _subHeader('Campaign Points'),
                _scoreRow('Ad Impression', '+0.1'),
                _scoreRow('Ad Click', '+0.5'),
                _scoreRow('Ad Reaction', '+1.5'),
                _scoreRow('Ad Comment', '+2.5'),
                _scoreRow('Ad Share', '+4.0'),
                _scoreRow('Watch Ad 10s+', '+2.0'),
                const SizedBox(height: 20),

                // Section 4: Bonuses
                _sectionHeader('bonuses', 'Bonuses & Multipliers'),
                const SizedBox(height: 8),
                _infoText(
                    'Stay active consistently and earn bonus multipliers on top of your base score!'),
                const SizedBox(height: 8),
                _bonusTierRow('7-Day Streak', '+10%', Colors.blue),
                _bonusTierRow('30-Day Streak', '+25%', Colors.orange),
                _bonusTierRow('90-Day Streak', '+50%', Colors.red),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PRIMARY_COLOR.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: PRIMARY_COLOR.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, color: PRIMARY_COLOR, size: 18),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Verified Creator Bonus: +15%',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                _infoText('Bonuses stack — a verified creator with a 30-day streak gets +40% bonus!'),
                const SizedBox(height: 20),

                // Section 5: Distribution
                _sectionHeader('distribution', 'Revenue Distribution'),
                const SizedBox(height: 8),
                _distributionSplitRow(),
                const SizedBox(height: 12),
                _infoText(
                    'Daily ad revenue is split 50/50 between the Creator Pool and Platform Operations.'),
                const SizedBox(height: 8),
                _stepCard(1, 'Revenue Collected',
                    'Total ad revenue for the day is calculated.'),
                _stepCard(2, '50% Creator Pool',
                    'Half of the revenue goes into the creator pool for distribution.'),
                _stepCard(3, 'Proportional Split',
                    'Each user receives their share based on points. A 10% per-user cap applies.'),
                const SizedBox(height: 20),

                // Section 6: Eligibility
                _sectionHeader('eligibility', 'Eligibility Requirements'),
                const SizedBox(height: 8),
                _eligibilityRow(Icons.calendar_today, 'Account age 7+ days'),
                _eligibilityRow(Icons.toggle_on, 'Monetization enabled in settings'),
                _eligibilityRow(Icons.trending_up, 'Minimum 1 point per day'),
                _eligibilityRow(Icons.person, 'Active, non-suspended account'),
                const SizedBox(height: 20),

                // Section 7: Tips
                _sectionHeader('tips', 'Pro Tips to Maximize Earnings'),
                const SizedBox(height: 8),
                _tipCard(true, 'Post quality content that gets engagement'),
                _tipCard(true, 'Engage with others — reactions, comments, shares'),
                _tipCard(true, 'Maintain daily streaks for bonus multipliers'),
                _tipCard(true, 'Run campaigns to earn campaign points'),
                _tipCard(true, 'Verify your creator account for +15%'),
                _tipCard(true, 'Check your dashboard daily to track progress'),
                const SizedBox(height: 8),
                _tipCard(false, 'Don\'t use bots or automation'),
                _tipCard(false, 'Don\'t spam or post low-quality content'),
                _tipCard(false, 'Don\'t create fake accounts for engagement'),
                _tipCard(false, 'Don\'t break your streak — you lose the bonus!'),
                const SizedBox(height: 20),

                // Section 8: FAQ
                _sectionHeader('faq', 'Frequently Asked Questions'),
                const SizedBox(height: 8),
                _faqItem('When do I get paid?',
                    'Earnings are calculated and credited daily at 12:00 AM UTC. You can withdraw once your balance reaches \$50.'),
                _faqItem('Why am I not earning anything?',
                    'Make sure monetization is enabled, your account is 7+ days old, and you earned at least 1 point today. Check your Activity Score on the dashboard.'),
                _faqItem('How is the creator pool calculated?',
                    'The creator pool is 50% of the day\'s total ad revenue. Your share = (Your Points / Total Points) × Creator Pool.'),
                _faqItem('What is the minimum withdrawal?',
                    '\$50 USD. You need a connected and verified Stripe account to withdraw.'),
                _faqItem('Do Page earnings count too?',
                    'Yes! If you manage Pages, engagement on your Page content earns points which contribute to your score.'),
                _faqItem('How do I maintain my streak?',
                    'Earn at least 1 point per day. Any qualifying activity (reaction, comment, share, etc.) counts.'),
                _faqItem('What is the 10% cap?',
                    'No single user can earn more than 10% of the daily creator pool. This ensures fair distribution among all participants.'),
                _faqItem('Can I have multiple accounts?',
                    'No. Multi-accounting violates our terms of service and will result in suspension of all accounts.'),
                _faqItem('How do I get verified?',
                    'Apply for creator verification through your account settings. Verified creators earn a +15% bonus on their score.'),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _quickStatsBanner() {
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
        border: Border.all(color: PRIMARY_COLOR.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _quickStat('50%', 'Rev Share'),
          _quickStatDivider(),
          _quickStat('12 AM UTC', 'Payout'),
          _quickStatDivider(),
          _quickStat('+50%', 'Max Streak'),
          _quickStatDivider(),
          _quickStat('+15%', 'Verified'),
        ],
      ),
    );
  }

  Widget _quickStat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: PRIMARY_COLOR)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
      ],
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
              style: const TextStyle(fontSize: 13, color: Colors.black87)),
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

  Widget _distributionSplitRow() {
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
                const Text('50%',
                    style: TextStyle(
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
                const Text('50%',
                    style: TextStyle(
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
                style: const TextStyle(fontSize: 13, color: Colors.black87)),
          ),
          Icon(Icons.check_circle,
              size: 16, color: Colors.green.shade400),
        ],
      ),
    );
  }

  Widget _tipCard(bool isDo, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDo
            ? Colors.green.shade50
            : Colors.red.shade50,
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
                style: const TextStyle(fontSize: 13, color: Colors.black87)),
          ),
        ],
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

  const _AccordionWidget({required this.question, required this.answer});

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
                            fontSize: 13, fontWeight: FontWeight.w600)),
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
              padding:
                  const EdgeInsets.only(left: 12, right: 12, bottom: 12),
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
