import 'package:flutter/material.dart';

void showStreakRulesBottomSheet(BuildContext context, int currentStreak) {
  final streakTiers = [
    _StreakTier(days: 7, bonus: 10, label: '7+ days', icon: '🔥'),
    _StreakTier(days: 30, bonus: 25, label: '30+ days', icon: '🔥🔥'),
    _StreakTier(days: 90, bonus: 50, label: '90+ days', icon: '🔥🔥🔥'),
  ];

  final currentTier =
      streakTiers.where((t) => currentStreak >= t.days).lastOrNull;
  final nextTier =
      streakTiers.where((t) => currentStreak < t.days).firstOrNull;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.orange.shade500, Colors.red.shade500]),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department,
                      color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  const Text('Streak Bonus Rules',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(16),
                children: [
                  // Current streak status
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade50,
                            Colors.red.shade50
                          ]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 36)),
                        const SizedBox(height: 8),
                        Text('$currentStreak Days',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87)),
                        const SizedBox(height: 4),
                        if (currentTier != null)
                          Text('+${currentTier.bonus}% bonus active!',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green.shade700))
                        else
                          const Text('Keep going to unlock bonuses!',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black54)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // How streaks work
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 16, color: Colors.blue.shade500),
                      const SizedBox(width: 6),
                      const Text('How Streaks Work',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your streak counts consecutive days of activity, not just logins.',
                          style: TextStyle(
                              fontSize: 13, color: Colors.blue.shade800),
                        ),
                        const SizedBox(height: 8),
                        Text('Activities that count:',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800)),
                        const SizedBox(height: 4),
                        ...[
                          'Reacting to posts',
                          'Commenting on posts',
                          'Sharing posts',
                          'Watching reels',
                          'Viewing stories',
                          'Interacting with ads'
                        ].map((a) => Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 2),
                              child: Text('• $a',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade700)),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Streak tiers
                  const Text('Streak Bonus Tiers',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  ...streakTiers.map((tier) {
                    final isAchieved = currentStreak >= tier.days;
                    final isCurrent = currentTier?.days == tier.days;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isAchieved
                            ? (isCurrent
                                ? Colors.orange.shade50
                                : Colors.green.shade50)
                            : Colors.grey.shade50,
                        border: Border.all(
                            color: isAchieved
                                ? (isCurrent
                                    ? Colors.orange.shade300
                                    : Colors.green.shade300)
                                : Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Text(tier.icon,
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(tier.label,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isAchieved
                                            ? Colors.black87
                                            : Colors.grey.shade500)),
                                Text(
                                  isAchieved
                                      ? 'Achieved!'
                                      : '${tier.days - currentStreak} days to go',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: isAchieved
                                          ? Colors.black54
                                          : Colors.grey.shade400),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '+${tier.bonus}%',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isAchieved
                                    ? Colors.green.shade700
                                    : Colors.grey.shade400),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Next goal
                  if (nextTier != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade50,
                              Colors.blue.shade50
                            ]),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.emoji_events,
                                  size: 18,
                                  color: Colors.purple.shade500),
                              const SizedBox(width: 6),
                              Text('Next Goal',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Colors.purple.shade800)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Reach ${nextTier.days} days to unlock +${nextTier.bonus}% bonus!',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.purple.shade700),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: currentStreak / nextTier.days,
                              minHeight: 10,
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      Colors.purple.shade400),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$currentStreak/${nextTier.days} days',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.purple.shade600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Verified creator bonus
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border:
                          Border.all(color: Colors.blue.shade100),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.verified,
                                size: 16,
                                color: Colors.blue.shade500),
                            const SizedBox(width: 6),
                            Text('Verified Creator Bonus',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade800)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Verified accounts get an additional +15% bonus that stacks with streak bonuses!',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _StreakTier {
  final int days;
  final int bonus;
  final String label;
  final String icon;
  const _StreakTier(
      {required this.days,
      required this.bonus,
      required this.label,
      required this.icon});
}
