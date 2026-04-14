import 'package:flutter/material.dart';

/// Card displaying live boost campaign performance analytics.
/// Shows impressions, clicks, reach, and CTR metrics.
class BoostPerformanceCard extends StatelessWidget {
  final Map<String, dynamic> analytics;
  final String status;

  const BoostPerformanceCard({
    super.key,
    required this.analytics,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final impressions = analytics['impressions'] as int? ?? 0;
    final clicks = analytics['clicks'] as int? ?? 0;
    final reach = analytics['reach'] as int? ?? 0;
    final spent = (analytics['spent'] as num?)?.toDouble() ?? 0.0;
    final ctr = impressions > 0 ? (clicks / impressions * 100) : 0.0;

    return Card(
      elevation: 0,
      color: isDark ? Colors.grey[900] : Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Boost Performance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _statusBadge(status),
              ],
            ),
            const SizedBox(height: 16),

            // Metrics grid
            Row(
              children: [
                Expanded(
                  child: _metricTile(
                    label: 'Impressions',
                    value: _formatNumber(impressions),
                    icon: Icons.visibility_outlined,
                    color: Colors.blue,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricTile(
                    label: 'Clicks',
                    value: _formatNumber(clicks),
                    icon: Icons.touch_app_outlined,
                    color: Colors.green,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _metricTile(
                    label: 'Reach',
                    value: _formatNumber(reach),
                    icon: Icons.people_outline,
                    color: Colors.purple,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricTile(
                    label: 'CTR',
                    value: '${ctr.toStringAsFixed(2)}%',
                    icon: Icons.trending_up,
                    color: Colors.orange,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Spend bar
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payments_outlined,
                          size: 18, color: Colors.grey[500]),
                      const SizedBox(width: 8),
                      Text(
                        'Amount Spent',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  Text(
                    '\$${spent.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bgColor;
    Color textColor;
    switch (status.toLowerCase()) {
      case 'active':
        bgColor = Colors.green.withOpacity(0.15);
        textColor = Colors.green[700]!;
        break;
      case 'paused':
        bgColor = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange[700]!;
        break;
      case 'completed':
        bgColor = Colors.grey.withOpacity(0.15);
        textColor = Colors.grey[700]!;
        break;
      case 'pending':
        bgColor = Colors.blue.withOpacity(0.15);
        textColor = Colors.blue[700]!;
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.15);
        textColor = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.capitalize ?? status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _formatNumber(int num) {
    if (num >= 1000000) return '${(num / 1000000).toStringAsFixed(1)}M';
    if (num >= 1000) return '${(num / 1000).toStringAsFixed(1)}K';
    return num.toString();
  }
}
